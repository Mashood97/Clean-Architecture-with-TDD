import '../../models/article_model.dart';

abstract class ArticleLocalDataSourceRepository {
  /// Calls the cache data of last api result.
  ///
  ///Throws a [CacheException] for all error codes
  Future<List<ArticleModel>> getAllArticlesFromLocal();
  Future<ArticleModel> getAllArticleByIdFromLocal(int? articleId);
  Future<void> cacheAllArticles(List<ArticleModel> articles);
}
