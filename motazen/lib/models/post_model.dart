// ignore_for_file: prefer_typing_uninitialized_variables

class PostModel {
  String? author;
  String? authorId;
  final time;
  final text;
  final comments;
  final replyingPost;
  final likes;
  String? postType;
  final imageURL;
  PostModel(
      {this.author,
      this.authorId,
      this.text,
      this.time,
      required this.comments,
      required this.likes,
      required this.replyingPost,
      required this.postType,
      required this.imageURL});

  Map<String, dynamic> toJson() => {
        'author': author,
        'author_id': authorId,
        'time': time,
        'text': text,
        'post_type': postType,
        'image_url': imageURL
      };
}
