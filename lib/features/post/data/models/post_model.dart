import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required final int userId,
    required final int postId,
    required final String postTitle,
    required final String postBody,
  }) : super(
          postBody: postBody,
          postId: postId,
          postTitle: postTitle,
          userId: userId,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postBody: json['body'],
      postId: json['id'],
      postTitle: json['title'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": postId,
      "title": postTitle,
      "body": postBody,
      "userId": userId,
    };
  }
}
