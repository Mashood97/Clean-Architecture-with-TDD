import 'package:equatable/equatable.dart';

class Article extends Equatable {
//   "userId": 1,
// "id": 1,
// "title": "delectus aut autem",
// "completed": false
  final int articleId;
  final String title;

  const Article({
    required this.articleId,
    required this.title,
  });

  @override
  List<Object?> get props => [
        articleId,
        title,
      ];
}
