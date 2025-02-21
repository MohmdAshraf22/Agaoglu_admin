import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
// import 'package:rxdart/rxdart.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

class VoiceBuilder extends StatefulWidget {
  final Function(File?)? onRecordComplete;
  final String? initialAudioPath;

  const VoiceBuilder({
    super.key,
    this.onRecordComplete,
    this.initialAudioPath,
  });

  @override
  State<VoiceBuilder> createState() => _VoiceBuilderState();
}

class _VoiceBuilderState extends State<VoiceBuilder> {
  late final AudioRecorder _audioRecorder;
  late final AudioPlayer _audioPlayer;
  File? _audioFile;
  bool _isRecording = false;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });

    if (widget.initialAudioPath != null) {
      _audioFile = File(widget.initialAudioPath!);
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await Permission.microphone.request();
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/audio.m4a';

        await _audioRecorder.start(const RecordConfig(), path: filePath);
        setState(() {
          _isRecording = true;
          _audioFile = null;
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();
      if (path != null) {
        setState(() {
          _isRecording = false;
          _audioFile = File(path);
        });
        widget.onRecordComplete?.call(_audioFile);
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _playPauseAudio() async {
    if (_audioFile != null) {
      try {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play(DeviceFileSource(_audioFile!.path));
        }
        setState(() {
          _isPlaying = !_isPlaying;
        });
      } catch (e) {
        debugPrint('Error playing audio: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_audioFile != null)
          Slider(
            value: _position.inSeconds.toDouble(),
            min: 0,
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                size: 40,
                color: ColorManager.orange,
              ),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            ),
            if (_audioFile != null)
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                  color: ColorManager.primary,
                ),
                onPressed: _playPauseAudio,
              ),
          ],
        ),
      ],
    );
  }
}

////
class AudioPlayerBuilder extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerBuilder({super.key, required this.audioUrl});

  @override
  State<AudioPlayerBuilder> createState() => _AudioPlayerBuilderState();
}

class _AudioPlayerBuilderState extends State<AudioPlayerBuilder> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  final Duration _bufferedPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setSource(UrlSource(widget.audioUrl));

      // Listen to position updates
      _audioPlayer.onPositionChanged.listen((pos) {
        setState(() => _position = pos);
      });

      // Listen to duration updates
      _audioPlayer.onDurationChanged.listen((dur) {
        setState(() => _totalDuration = dur);
      });

      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() => _isPlaying = state == PlayerState.playing);
      });
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 2.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: .5.h),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SeekBar(
                duration: _totalDuration,
                position: _position,
                bufferedPosition: _bufferedPosition,
                onChangeEnd: (newPosition) => _audioPlayer.seek(newPosition),
              ),
            ),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: ColorManager.orange,
                size: 35,
              ),
              onPressed: _playAudio,
            ),
          ],
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double max = widget.duration.inMilliseconds.toDouble();
    final double position =
        widget.position.inMilliseconds.toDouble().clamp(0, max);
    final double bufferedPosition =
        widget.bufferedPosition.inMilliseconds.toDouble().clamp(0, max);

    return Row(
      children: [
        SizedBox(width: 2.w),
        Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})')
                    .firstMatch(_remaining)
                    ?.group(1) ??
                _remaining,
            style: Theme.of(context).textTheme.bodySmall),
        Stack(
          children: [
            SliderTheme(
              data: _sliderThemeData.copyWith(
                thumbShape: HiddenThumbComponentShape(),
                activeTrackColor: Colors.orange.shade100,
                inactiveTrackColor: Colors.grey.shade300,
              ),
              child: ExcludeSemantics(
                child: Slider(
                  min: 0.0,
                  max: max,
                  value: bufferedPosition,
                  onChanged: (value) {},
                ),
              ),
            ),
            SliderTheme(
              data: _sliderThemeData.copyWith(
                inactiveTrackColor: Colors.transparent,
              ),
              child: Slider(
                min: 0.0,
                max: max,
                activeColor: ColorManager.orange,
                value: _dragValue ?? position,
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String get _remaining =>
      RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})')
          .firstMatch("${widget.duration - widget.position}")
          ?.group(1) ??
      '${widget.duration - widget.position}';
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.zero;
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}
