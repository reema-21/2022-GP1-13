// ignore_for_file: prefer_typing_uninitialized_variables

class NotificationModel {
  final comm;
  final post;
  final userName;
  final reply;
  final notificationOfTheCommunity;
  DateTime creationDate;
  String? notificationType;
  NotificationModel(
      {this.notificationType,
      required this.comm,
      required this.post,
      required this.reply,
      required this.userName,
      required this.creationDate,
      required this.notificationOfTheCommunity});

  Map<String, dynamic> toJson() => {
        'community': comm,
        'post': post,
        'user_name': userName,
        'reply': reply,
        'type': notificationType,
        'creation_date': creationDate,
        'community_link': notificationOfTheCommunity
      };
}
