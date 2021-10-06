import 'package:flutter_api_clean_architecture/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/usecases/get_single_article_usecase.dart';
import 'package:get/get.dart';

class ArticleController extends GetxController {
  GetArticlesUseCase? getArticlesUseCase;
  GetSingleArticleUseCase? getSingleArticleUseCase;

  ArticleController({
    required this.getArticlesUseCase,
    required this.getSingleArticleUseCase,
  });
}
