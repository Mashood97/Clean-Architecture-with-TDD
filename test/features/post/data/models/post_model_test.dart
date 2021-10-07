import 'dart:convert';

import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  PostModel postModel = const PostModel(
      userId: 1,
      postId: 1,
      postTitle: "to make a blinded choice to reject or provident to task",
      postBody:
          "since he receives and receives the accepted consequences unencumbered, and when he finds any annoyance that as soon as the whole of our affairs is and they are a thing, it will happen to the architect");

  test("should be a subclass of Post Entity", () async {
    expect(postModel, isA<PostEntity>());
  });

  group('from Json', () {
    test(
      "Should return a valid post",
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixture('post.json'));

        final result = PostModel.fromJson(jsonMap);

        expect(result, postModel);
      },
    );
  });
  group('To Json', () {
    test(
      "Should return a valid post",
      () async {
        final result = postModel.toJson();
        final data = {
          "userId": 1,
          "id": 1,
          "title": "to make a blinded choice to reject or provident to task",
          "body":
              "since he receives and receives the accepted consequences unencumbered, and when he finds any annoyance that as soon as the whole of our affairs is and they are a thing, it will happen to the architect"
        };
        expect(result, data);
      },
    );
  });
}
