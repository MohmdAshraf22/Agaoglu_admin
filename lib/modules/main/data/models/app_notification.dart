class AppNotification {
  final String title;
  final String body;
  final String taskId;

  AppNotification({
    required this.title,
    required this.body,
    required this.taskId,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      taskId: json['taskId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'taskId': taskId,
    };
  }
}
