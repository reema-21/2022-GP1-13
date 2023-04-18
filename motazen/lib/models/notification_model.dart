class NotificationModel {
  final String senderAvtar;
  final String senderID;
  final dynamic comm;
  final dynamic post;
  final String userName;
  final dynamic reply;
  final dynamic notificationOfTheCommunity;
  DateTime creationDate;
  String? notificationType;
  NotificationModel(
      {this.notificationType,
      required this.comm,
      required this.post,
      required this.reply,
      required this.userName,
      required this.creationDate,
      required this.notificationOfTheCommunity,
      required this.senderAvtar,
      required this.senderID});

  Map<String, dynamic> toJson() => {
        'community': comm,
        'post': post,
        'userName': userName,
        'reply': reply,
        'type': notificationType,
        'creation_date': creationDate,
        'community_link': notificationOfTheCommunity,
        'sender_avatar': senderAvtar,
        'sender_id': senderID
      };
}
