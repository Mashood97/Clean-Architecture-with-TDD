import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required int articleId,
    required String title,
  }) : super(
          articleId: articleId,
          title: title,
        );

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(articleId: json['id'], title: json['title']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": articleId,
      "title": title,
    };
  }
}
