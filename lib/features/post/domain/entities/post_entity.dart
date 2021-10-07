import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int userId;
  final int postId;
  final String postTitle;
  final String postBody;

  const PostEntity({
    required this.postBody,
    required this.postId,
    required this.postTitle,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        userId,
        postBody,
        postId,
        postTitle,
      ];
}
