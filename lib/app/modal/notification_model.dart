class NotificationModel {
  final String? timestamp;
  final DateTime? date;
  final String? title;
  final String? body;
  late final int? postID;
  final String? thumbnailUrl;

  NotificationModel({
    this.timestamp,
    this.date,
    this.title,
    this.body,
    this.postID,
    this.thumbnailUrl,
  });
}
