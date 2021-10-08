import 'dart:convert';

//Here we check the models inside data layer i.e extends entity, from json and to json methods.
import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  PostModel tPost =
      const PostModel(postId: 1, title: "test", userId: 1, body: "test");

  test("should be a subclass of post Entity", () async {
    expect(tPost, isA<PostEntity>());
  });

  //here we will be test check if model returns a valid article.

  group('from Json', () {
    test(
      "Should return a valid post",
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixture('post.json'));

        final result = PostModel.fromJson(jsonMap);

        expect(result, tPost);
      },
    );
  });

  group('ToJson', () {
    test("Should return a valid json on sending proper data", () async {
      final result = tPost.toJson();
      final data = {
        "userId": 1,
        "id": 1,
        "title": "test",
        "body": "test",
      };
      expect(result, data);
    });
  });
}
