import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/core/platform/network_info.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/datasources/local/article_local_data_source_repo.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/datasources/remote/article_remote_data_source_repository.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/models/article_model.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/repositories/article_repository_impl.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/entities/article.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRemoteDataSource extends Mock
    implements ArticleRemoteDataSourceRepository {}

class MockArticleLocalDataSource extends Mock
    implements ArticleLocalDataSourceRepository {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ArticleRepositoryImplementation articleRepositoryImplementation;
  late MockArticleRemoteDataSource mockArticleRemoteDataSource;
  late MockArticleLocalDataSource mockArticleLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockArticleLocalDataSource = MockArticleLocalDataSource();
    mockArticleRemoteDataSource = MockArticleRemoteDataSource();
    articleRepositoryImplementation = ArticleRepositoryImplementation(
      networkInfo: mockNetworkInfo,
      remoteSource: mockArticleRemoteDataSource,
      localSource: mockArticleLocalDataSource,
    );
  });

  void runTestOnline(Function body) {
    group("Device is online", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("Device is offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group("Get Articles By ID", () {
    int tArticleId = 1;
    ArticleModel tArticleModel =
        const ArticleModel(articleId: 1, title: "test article");
    Article tArticleEntity = tArticleModel;
    List<ArticleModel> articles = const [
      ArticleModel(articleId: 1, title: "test"),
      ArticleModel(articleId: 2, title: "test"),
    ];
    List<Article> articlesEntity = articles;
    test("Should check if device is connected to internet...", () async {
      when(() => mockArticleRemoteDataSource.getAllArticleById(any()))
          .thenAnswer(
              (_) async => const ArticleModel(title: 'test', articleId: 1));
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      await articleRepositoryImplementation.getAllArticleById(tArticleId);

      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        "Should return remote data when the call to remote data is success:",
        () async {
          when(() => mockArticleRemoteDataSource.getAllArticleById(tArticleId))
              .thenAnswer((_) async => tArticleModel);

          final result = await articleRepositoryImplementation
              .getAllArticleById(tArticleId);

          expect(
            result,
            equals(
              Right(tArticleEntity),
            ),
          );
        },
      );

      test(
        "Should return server exception data when the call to remote data is unsuccess:",
        () async {
          when(() => mockArticleRemoteDataSource.getAllArticleById(tArticleId))
              .thenThrow(ServerException());

          final result = await articleRepositoryImplementation
              .getAllArticleById(tArticleId);

          verify(
              () => mockArticleRemoteDataSource.getAllArticleById(tArticleId));
          verifyZeroInteractions(mockArticleLocalDataSource);
          expect(
            result,
            equals(
              Left(ServerFailure()),
            ),
          );
        },
      );
    });
    runTestOffline(() {
      test(
          "Should return last locally articles cached when the cached data is present",
          () async {
        when(() => mockArticleLocalDataSource
            .getAllArticleByIdFromLocal(tArticleId)).thenAnswer(
          (_) async => tArticleModel,
        );
        final resultId =
            await articleRepositoryImplementation.getAllArticleById(tArticleId);

        verifyZeroInteractions(mockArticleRemoteDataSource);
        verify(
          () =>
              mockArticleLocalDataSource.getAllArticleByIdFromLocal(tArticleId),
        );

        expect(
          resultId,
          equals(
            Right(tArticleEntity),
          ),
        );
      });

      test("Should return CacheFailure when there is not cached data present.",
          () async {
        when(() => mockArticleLocalDataSource
            .getAllArticleByIdFromLocal(tArticleId)).thenThrow(
          CacheException(),
        );
        final resultId =
            await articleRepositoryImplementation.getAllArticleById(tArticleId);

        verifyZeroInteractions(mockArticleRemoteDataSource);
        verify(
          () =>
              mockArticleLocalDataSource.getAllArticleByIdFromLocal(tArticleId),
        );

        expect(
          resultId,
          equals(
            Left(CacheFailure()),
          ),
        );
      });
    });
  });
  group("Get All Articles", () {
    List<ArticleModel> articles = const [
      ArticleModel(articleId: 1, title: "test"),
      ArticleModel(articleId: 2, title: "test"),
    ];
    List<Article> articlesEntity = articles;
    test("Should check if device is connected to internet...", () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockArticleRemoteDataSource.getAllArticles())
          .thenAnswer((_) async => const [
                ArticleModel(articleId: 1, title: "test"),
                ArticleModel(articleId: 2, title: "test"),
              ]);
      when(() => mockArticleLocalDataSource.cacheAllArticles(articles))
          .thenAnswer((_) async => const [
                ArticleModel(articleId: 1, title: "test"),
                ArticleModel(articleId: 2, title: "test"),
              ]);

      await articleRepositoryImplementation.getAllArticles();

      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        "Should return remote data when the call to remote data is success:",
        () async {
          when(() => mockArticleRemoteDataSource.getAllArticles())
              .thenAnswer((_) async => articles);
          when(() => mockArticleLocalDataSource.cacheAllArticles(articles))
              .thenAnswer((_) async => const [
                    ArticleModel(articleId: 1, title: "test"),
                    ArticleModel(articleId: 2, title: "test"),
                  ]);
          final result = await articleRepositoryImplementation.getAllArticles();

          expect(
            result,
            equals(
              Right(articlesEntity),
            ),
          );
        },
      );

      test(
          "Should catch the data locally when call to remote data source is success:",
          () async {
        when(() => mockArticleRemoteDataSource.getAllArticles())
            .thenAnswer((_) async => articles);
        when(() => mockArticleLocalDataSource.cacheAllArticles(articles))
            .thenAnswer((_) async => articles);

        await articleRepositoryImplementation.getAllArticles();

        verify(() => mockArticleRemoteDataSource.getAllArticles());
        verify(() => mockArticleLocalDataSource.cacheAllArticles(articles));
      });

      test(
        "Should return server exception data when the call to remote data is unsuccess:",
        () async {
          when(() => mockArticleRemoteDataSource.getAllArticles())
              .thenThrow(ServerException());

          final result = await articleRepositoryImplementation.getAllArticles();

          verify(() => mockArticleRemoteDataSource.getAllArticles());
          verifyZeroInteractions(mockArticleLocalDataSource);
          expect(
            result,
            equals(
              Left(ServerFailure()),
            ),
          );
        },
      );
    });
    runTestOffline(() {
      test(
          "Should return last locally articles cached when the cached data is present",
          () async {
        when(() => mockArticleLocalDataSource.getAllArticlesFromLocal())
            .thenAnswer(
          (_) async => articles,
        );

        final result = await articleRepositoryImplementation.getAllArticles();

        verifyZeroInteractions(mockArticleRemoteDataSource);
        verify(() => mockArticleLocalDataSource.getAllArticlesFromLocal());

        expect(
          result,
          equals(
            Right(articlesEntity),
          ),
        );
      });

      test("Should return CacheFailure when there is not cached data present.",
          () async {
        when(() => mockArticleLocalDataSource.getAllArticlesFromLocal())
            .thenThrow(
          CacheException(),
        );

        final result = await articleRepositoryImplementation.getAllArticles();

        verifyZeroInteractions(mockArticleRemoteDataSource);
        verify(() => mockArticleLocalDataSource.getAllArticlesFromLocal());

        expect(
          result,
          equals(
            Left(CacheFailure()),
          ),
        );
      });
    });
  });
}
