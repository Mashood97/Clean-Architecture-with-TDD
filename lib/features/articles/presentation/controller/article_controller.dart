import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../domain/usecases/get_single_article_usecase.dart';
import 'package:get/get.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class ArticleController extends GetxController {
  GetArticlesUseCase? getArticlesUseCase;
  GetSingleArticleUseCase? getSingleArticleUseCase;

  ArticleController({
    required this.getArticlesUseCase,
    required this.getSingleArticleUseCase,
  });

  final RxList<Article> _articles = RxList();

  List<Article> get articles => [..._articles];

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  setIsLoading(bool val) {
    _isLoading.value = val;
    update();
  }

  Future getAllArticles() async {
    setIsLoading(true);

    final Either<Failure, List<Article>> response =
        await getArticlesUseCase!.articleRepository.getAllArticles();
    response
        .fold((failure) => Get.snackbar("Error", _mapFailureToMessage(failure)),
            (articlesList) {
      _articles.addAll(articlesList);
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
    await getAllArticles();
    super.onInit();
  }
}
