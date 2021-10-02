import '../../models/article_model.dart';

abstract class ArticleRemoteDataSourceRepository {
  /// Calls the https://jsonplaceholder.typicode.com/{todos} endpoint
  ///
  ///Throws a [ServerException] for all error codes
  Future<List<ArticleModel>> getAllArticles();
  Future<ArticleModel> getAllArticleById(int? articleId);
}
