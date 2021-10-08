import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../domain/usecases/get_single_article_usecase.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class SingleArticleController extends GetxController {
  GetArticlesUseCase? getArticlesUseCase;
  GetSingleArticleUseCase? getSingleArticleUseCase;

  SingleArticleController({
    required this.getArticlesUseCase,
    required this.getSingleArticleUseCase,
  });

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  setIsLoading(bool val) {
    _isLoading.value = val;
    update();
  }

  late final Rx<Article> _article;

  Article get article => _article.value;

  int _articleId = 0;
  Future getAllArticles() async {
    setIsLoading(true);

    final Either<Failure, Article> response = await getArticlesUseCase!
        .articleRepository
        .getAllArticleById(_articleId);
    response
        .fold((failure) => Get.snackbar("Error", _mapFailureToMessage(failure)),
            (article) {
      _article = Rx<Article>(
        Article(articleId: article.articleId, title: article.title),
      );
    });

    setIsLoading(false);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  @override
  void onInit() async {
    _articleId = Get.arguments as int;
    await getAllArticles();
    super.onInit();
  }
}
