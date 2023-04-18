class PostModel {
  String? author;
  String? authorId;
  final dynamic time;
  final dynamic text;
  final dynamic comments;
  final dynamic replyingPost;
  final dynamic likes;
  final dynamic progreebar;
  String? postType;
  final dynamic imageURL;
  PostModel(
      {this.author,
      this.authorId,
      this.text,
      this.time,
      this.progreebar,
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
        'progreebar': progreebar,
        'post_type': postType,
        'image_url': imageURL
      };
}
