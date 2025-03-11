import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

// import 'package:rxdart/rxdart.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/modules/task/cubit/task_cubit.dart';

class VoiceBuilder extends StatefulWidget {
  final Function(File?)? onRecordComplete;
  final String? initialAudioPath;
  final String? audioUrl;
  final String taskId;

  const VoiceBuilder({
    super.key,
    this.onRecordComplete,
    this.initialAudioPath,
    this.audioUrl,
    required this.taskId,
  });

  @override
  State<VoiceBuilder> createState() => _VoiceBuilderState();
}

class _VoiceBuilderState extends State<VoiceBuilder> {
  late final AudioRecorder _audioRecorder;
  late final AudioPlayer _audioPlayer;
  File? _audioFile;
  String? _audioUrl;
  bool _isRecording = false;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    _audioUrl = widget.audioUrl;
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
          _audioUrl = null;
        });
      }
    } catch (e) {
      throw Exception('Error starting recording: $e');
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
      throw Exception('Error starting recording: $e');
    }
  }

  Future<void> _deleteAudio() async {
    try {
      if (_audioUrl != null) {
        context.read<TaskCubit>().deleteFile(_audioUrl!, widget.taskId);
        setState(() {
          _audioUrl = null;
        });
      }
    } catch (e) {
      throw Exception('Error deleting audio: $e');
    }
  }

  Future<void> _playPauseAudio() async {
    if (_audioUrl != null) {
      try {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play(UrlSource(_audioUrl!));
        }
        setState(() {
          _isPlaying = !_isPlaying;
        });
      } catch (e) {
        throw Exception('Error starting recording: $e');
      }
    } else if (_audioFile != null) {
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
        throw Exception('Error starting recording: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_audioFile != null || _audioUrl != null)
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
                _audioUrl != null
                    ? Icons.delete
                    : _isRecording
                        ? Icons.stop
                        : Icons.mic,
                size: 35,
                color: ColorManager.orange,
              ),
              onPressed: _audioUrl != null
                  ? _deleteAudio
                  : _isRecording
                      ? _stopRecording
                      : _startRecording,
            ),
            if (_audioFile != null || _audioUrl != null)
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
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      _audioPlayer = AudioPlayer();
      _audioPlayer.onDurationChanged.listen((newDuration) {
        setState(() {
          _totalDuration = newDuration;
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
    } catch (e) {
      throw Exception('Error initializing audio player: $e');
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
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
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
              child: Row(
                children: [
                  SizedBox(width: 2.w),
                  Text(
                      RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})')
                              .firstMatch(_remaining)
                              ?.group(1) ??
                          _remaining,
                      style: Theme.of(context).textTheme.bodySmall),
                  Slider(
                    value: _position.inSeconds.toDouble(),
                    min: 0,
                    max: _totalDuration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ],
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

  String get _remaining =>
      RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})')
          .firstMatch("${_totalDuration - _position}")
          ?.group(1) ??
      '${_totalDuration - _position}';
}
