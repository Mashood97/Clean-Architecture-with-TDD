import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../models/article_model.dart';

abstract class ArticleRemoteDataSourceRepository {
  /// Calls the https://jsonplaceholder.typicode.com/{todos} endpoint
  ///
  ///Throws a [ServerException] for all error codes
  Future<List<ArticleModel>> getAllArticles();
  Future<ArticleModel> getAllArticleById(int? articleId);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSourceRepository {
  final Dio dio;
  ArticleRemoteDataSourceImpl({required this.dio});

  @override
  Future<ArticleModel> getAllArticleById(int? articleId) async {
    Response response = await dio.get(
        'https://jsonplaceholder.typicode.com/todos/$articleId',
        options: Options(contentType: 'application/json'));

    if (response.statusCode == 200) {
      var decode = response.data;

      //Whenever For testing add json decoded
      // var decode = json.decode(response.data);
      ArticleModel article = ArticleModel.fromJson(decode);
      return article;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ArticleModel>> getAllArticles() async {
    Response response = await dio.get(
        'https://jsonplaceholder.typicode.com/todos',
        options: Options(contentType: 'application/json'));

    if (response.statusCode == 200) {
      final List<ArticleModel> _articles = [];

      var decode = response.data;
      //Whenever For testing add json decoded
      // var decode = json.decode(response.data);
      for (var article in decode) {
        _articles.add(ArticleModel.fromJson(article));
      }

      return Future.value(_articles);
    } else {
      throw ServerException();
    }
  }
}
