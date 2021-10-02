import 'dart:convert';

import 'package:flutter_api_clean_architecture/features/articles/data/models/article_model.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/entities/article.dart';
import 'package:flutter_test/flutter_test.dart';

//Here we check the models inside data layer i.e extends entity, from json and to json methods.
import '../../../../fixtures/fixture_reader.dart';

void main() {
  ArticleModel tArticleModel = const ArticleModel(articleId: 1, title: "test");

  test("should be a subclass of Article Entity", () async {
    expect(tArticleModel, isA<Article>());
  });

  //here we will be test check if model returns a valid article.

  group('from Json', () {
    test(
      "Should return a valid article",
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('article.json'));

        final result = ArticleModel.fromJson(jsonMap);

        expect(result, tArticleModel);
      },
    );
  });

  group('ToJson', () {
    test("Should return a valid json on sending proper data", () async {
      final result = tArticleModel.toJson();
      final data = {"id": 1, "title": "test"};
      expect(result, data);
    });
  });
}
