import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required int userId,
    required int postId,
    required String title,
    required String body,
  }) : super(body: body, postId: postId, title: title, userId: userId);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        body: json['body'],
        postId: json['id'],
        title: json['title'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": postId,
      "userId": userId,
      "body": body,
      "title": title,
    };
  }
}
