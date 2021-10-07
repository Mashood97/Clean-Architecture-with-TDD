import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/article_model.dart';

abstract class ArticleLocalDataSourceRepository {
  /// Calls the cache data of last api result.
  ///
  ///Throws a [CacheException] for all error codes
  Future<List<ArticleModel>> getAllArticlesFromLocal();
  Future<ArticleModel> getAllArticleByIdFromLocal(int? articleId);
  Future<void> cacheAllArticles(List<ArticleModel>? articles);
}

const String CACHED_ALL_ARTICLES = "CACHED_ALL_ARTICLES";

class ArticleLocalDataSourceImpl extends ArticleLocalDataSourceRepository {
  final SharedPreferences sharedPreferences;

  ArticleLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<void> cacheAllArticles(List<ArticleModel>? articles) async {
    sharedPreferences.setString(
      CACHED_ALL_ARTICLES,
      json.encode(articles),
    );
  }

  @override
  Future<ArticleModel> getAllArticleByIdFromLocal(int? articleId) {
    final jsonString = sharedPreferences.getString('CACHED_ALL_ARTICLES');
    if (jsonString != null) {
      final articleList = json.decode(jsonString);
      // final article =
      //     articleList.firstWhere((element) => element['id'] == articleId!);

      return Future.value(ArticleModel.fromJson(articleList));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<ArticleModel>> getAllArticlesFromLocal() {
    final jsonString = sharedPreferences.getString('CACHED_ALL_ARTICLES');
    if (jsonString != null) {
      final List<ArticleModel> tArticlesList = [];
      List<dynamic> decoded = json.decode(jsonString);
      for (var article in decoded) {
        tArticlesList.add(ArticleModel.fromJson(article));
      }

      return Future.value(tArticlesList);
    } else {
      throw CacheException();
    }
  }
}
