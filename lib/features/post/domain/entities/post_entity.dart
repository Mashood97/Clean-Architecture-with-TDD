import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int userId;
  final int postId;
  final String title;
  final String body;

  const PostEntity({
    required this.body,
    required this.userId,
    required this.postId,
    required this.title,
  });
  @override
  List<Object?> get props => [userId, postId, title, body];
}
