import 'dart:convert';

import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/datasources/local/article_local_data_source_repo.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/models/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ArticleLocalDataSourceImpl articleLocalDataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();

    articleLocalDataSourceImpl =
        ArticleLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group("LocalDataSource", () {
    //get all articles from cache

    final List<ArticleModel> tArticlesList = [];
    List<dynamic> decoded = json.decode(fixture('articles.json'));
    for (var article in decoded) {
      tArticlesList.add(ArticleModel.fromJson(article));
    }

    test(
        "should get all articles from local data source when theres articles present in cache",
        () async {
      //arrange

      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('articles.json'));

      //act
      final result = await articleLocalDataSourceImpl.getAllArticlesFromLocal();

      //assert
      verify(() => mockSharedPreferences.getString("CACHED_ALL_ARTICLES"));
      expect(result, equals(tArticlesList));
    });

    test(
        "Should return cache exception where there is not data present inside cache",
        () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final call = articleLocalDataSourceImpl.getAllArticlesFromLocal;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("cache articles", () {
    final List<ArticleModel> tArticlesList = [];

    tArticlesList.addAll([
      ArticleModel.fromJson(
        const {"id": 1, "title": "test"},
      ),
      ArticleModel.fromJson(
        const {"id": 2, "title": "test"},
      ),
    ]);

    test("Should save articles when shared preferences call to save data",
        () async {
      when(() => mockSharedPreferences.setString(
              "CACHED_ALL_ARTICLES", json.encode(tArticlesList)))
          .thenAnswer((_) async => true);
      //act
      articleLocalDataSourceImpl.cacheAllArticles(tArticlesList);

      //assert
      final expectedJsonString = json.encode(tArticlesList);

      verify(() => mockSharedPreferences.setString(
          "CACHED_ALL_ARTICLES", expectedJsonString));
    });
  });
}
