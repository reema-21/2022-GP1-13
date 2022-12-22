// ignore_for_file: prefer_typing_uninitialized_variables

class PostModel {
  String? author;
  String? authorId;
  final time;
  String? text;
  final comments;
  final replyingPost;
  int? likes;
  PostModel(
      {this.author,
      this.authorId,
      this.text,
      this.time,
      required this.comments,
      required this.likes,
      required this.replyingPost});

  Map<String, dynamic> toJson() => {
        'author': author,
        'author_id': authorId,
        'time': time,
        'text': text,
        'comment': comments,
        'likes': likes,
      };
}
