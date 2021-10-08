import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockDioClient extends Mock implements Dio {}

void main() {
  late PostRemoteDataSourceRepositoryImplementation
      postRemoteDataSourceRepositoryImplementation;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    postRemoteDataSourceRepositoryImplementation =
        PostRemoteDataSourceRepositoryImplementation(dio: mockDioClient);
  });

  Future getSuccessApi({required String? fileName}) async {
    when(() => mockDioClient.get(
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
    when(() => mockDioClient.get(
          any(),
        )).thenAnswer((_) async => Response(
          data: '',
          statusCode: 404,
          requestOptions: RequestOptions(
            path: '',
          ),
        ));
  }

  group("Should get posts", () {
    final List<PostModel> tPostList = [];
    List<dynamic> decoded = json.decode(fixture('posts.json'));
    for (var post in decoded) {
      tPostList.add(PostModel.fromJson(post));
    }
    test("Should get all post when get request is performed", () async {
      //arrange

      await getSuccessApi(fileName: 'posts.json');

      //act
      final result = await postRemoteDataSourceRepositoryImplementation
          .getPostsFromServer();
      //assert

      verify(
        () => mockDioClient.get(
          'https://jsonplaceholder.typicode.com/posts',
        ),
      );

      expect(result, equals(tPostList));
    });

    test("Should return failure Exception when api throw exception", () async {
      await getErrorApi();

      final call =
          postRemoteDataSourceRepositoryImplementation.getPostsFromServer;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
