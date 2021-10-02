//First create a mock repo

import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/entities/article.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/repositories/article_repository.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/usecases/get_single_article_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetSingleArticleUseCase useCase;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    //setup all objects here.
    mockArticleRepository = MockArticleRepository();
    useCase = GetSingleArticleUseCase(articleRepository: mockArticleRepository);
  });

  //model class to be pass for testing

  int articleId = 1;

  Article singleArticle = const Article(articleId: 1, title: "test");

  //Here we define test logics since we want to test async function so we may use thenAnswer instead of thenResult.
  //any means any article id be pass here will be success.
  //Right here is from dartz package functional programming, this will return right means corrent always singlearticle.
  test("Should get a single article by article Id", () async {
    when(() => mockArticleRepository.getAllArticleById(articleId)).thenAnswer(
      (_) async => Right(singleArticle),
    );
    // The "act" phase of the test. Call the not-yet-existent method.

//Dart has a special function call which can be call with and without object of a class below function can
//be call like: useCase.call() or only with object usecase();
    final result = await useCase(Params(articleId: articleId));
    // UseCase should simply return whatever was returned from the Repository

    expect(result, Right(singleArticle));
    // Verify that the method has been called on the Repository

    verify(() => mockArticleRepository.getAllArticleById(articleId));
    // Only the above method should be called and nothing more.

    verifyNoMoreInteractions(mockArticleRepository);
  });
}
