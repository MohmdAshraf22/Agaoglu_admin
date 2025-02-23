import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum TaskStatus {
  all,
  pending,
  inProgress,
  approved,
  cancelled,
  completed,
}

class TaskModel extends Equatable {
  final String id;
  final String description;
  final String title;
  final String? workerName;
  final String? workerPhoto;
  final String? voiceUrl;
  final List<String> imagesUrl;
  final String? site;
  final String? block;
  final String? flat;
  final TaskStatus status;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.voiceUrl,
    required this.imagesUrl,
    this.workerName,
    this.block,
    this.flat,
    this.site,
    this.workerPhoto,
    required this.createdAt,
  });

  Map<String, dynamic> toMap(String id) {
    return {
      "id": id,
      'description': description,
      'title': title,
      'workerName': workerName,
      'workerPhoto': workerPhoto,
      'imagesUrl': imagesUrl,
      'voiceUrl': voiceUrl,
      'block': block,
      'flat': flat,
      'site': site,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TaskModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      workerName: data['workerName'],
      title: data['title'],
      workerPhoto: data['workerPhoto'],
      voiceUrl: data['voiceUrl'],
      imagesUrl: List<String>.from(data['imagesUrl']),
      site: data['site'],
      block: data['block'],
      flat: data['flat'],
      description: data['description'],
      status: TaskStatus.values.byName(data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        description,
        workerName,
        workerPhoto,
        status,
        createdAt,
        title,
        voiceUrl,
        imagesUrl,
        site,
        block,
        flat
      ];
}
