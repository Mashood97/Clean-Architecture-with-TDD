import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/entities/article.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/usecases/get_single_article_usecase.dart';
import 'package:get/get.dart';

class SingleArticleController extends GetxController {
  GetArticlesUseCase? getArticlesUseCase;
  GetSingleArticleUseCase? getSingleArticleUseCase;

  SingleArticleController({
    required this.getArticlesUseCase,
    required this.getSingleArticleUseCase,
  });
}
