import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/datasources/remote/article_remote_data_source_repository.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/models/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockDioClient extends Mock implements Dio {}

void main() {
  late ArticleRemoteDataSourceImpl articleRemoteDataSourceImpl;
  late MockDioClient dioClient;

  setUp(() {
    dioClient = MockDioClient();
    articleRemoteDataSourceImpl = ArticleRemoteDataSourceImpl(dio: dioClient);
  });

  Future getSuccessApi({required String? fileName}) async {
    when(() => dioClient.get(
          any(),
        )).thenAnswer((_) async => Response(
          data: fixture(fileName),
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ));
  }

  Future getErrorApi() async {
    when(() => dioClient.get(
          any(),
        )).thenAnswer((_) async => Response(
          data: 'something went wrong',
          statusCode: 404,
          requestOptions: RequestOptions(
            path: '',
          ),
        ));
  }

  group("Get All Articles", () {
    final List<ArticleModel> tArticlesList = [];
    List<dynamic> decoded = json.decode(fixture('articles.json'));
    for (var article in decoded) {
      tArticlesList.add(ArticleModel.fromJson(article));
    }
    test("Should get all articles when get request is performed", () async {
      //arrange

      await getSuccessApi(fileName: 'articles.json');

      //act
      final result = await articleRemoteDataSourceImpl.getAllArticles();
      //assert

      verify(
        () => dioClient.get(
          'https://jsonplaceholder.typicode.com/todos',
        ),
      );

      expect(result, equals(tArticlesList));
    });

    test("Should return failure Exception when api throw exception", () async {
      await getErrorApi();

      final call = articleRemoteDataSourceImpl.getAllArticles;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("GetArticles By ID", () {
    final singleArticle =
        ArticleModel.fromJson(json.decode(fixture('article.json')));
    int tArticleId = 1;

    test("Should get a single Article By Id ", () async {
      await getSuccessApi(fileName: 'article.json');

      //act
      final result =
          await articleRemoteDataSourceImpl.getAllArticleById(tArticleId);
      //assert

      verify(
        () => dioClient.get(
          'https://jsonplaceholder.typicode.com/todos/$tArticleId',
        ),
      );

      expect(result, equals(singleArticle));
    });

    test("Should return failure Exception when api throw exception", () async {
      await getErrorApi();

      final call = articleRemoteDataSourceImpl.getAllArticleById;

      expect(() => call(tArticleId),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
