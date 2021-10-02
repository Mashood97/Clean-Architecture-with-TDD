import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/entities/article.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/repositories/article_repository.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetArticlesUseCase useCase;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    useCase = GetArticlesUseCase(articleRepository: mockArticleRepository);
  });

  List<Article> articles = const [
    Article(articleId: 1, title: "test"),
    Article(articleId: 2, title: "test"),
  ];
  test("Should get all articles from server", () async {
    when(() => mockArticleRepository.getAllArticles())
        .thenAnswer((_) async => Right(articles));

    final result = await useCase(NoParams());

    expect(result, Right(articles));

    verify(() => mockArticleRepository.getAllArticles());

    verifyNoMoreInteractions(mockArticleRepository);
  });
}
