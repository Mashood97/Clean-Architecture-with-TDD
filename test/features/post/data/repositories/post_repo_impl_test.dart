import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_api_clean_architecture/features/post/data/repositories/post_repo_impl.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/utils/networking/http_exception.dart';
import 'package:flutter_api_clean_architecture/utils/networking/networking_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late PostRepoImpl postRepositoryImplementation;
  late MockPostRemoteDataSource mockPostRemoteDataSource;

  setUp(() {
    mockPostRemoteDataSource = MockPostRemoteDataSource();
    postRepositoryImplementation =
        PostRepoImpl(postRemoteDataSource: mockPostRemoteDataSource);
  });

  group("Should return all posts from server", () {
    List<PostModel> posts = const [
      PostModel(
        postBody:
            "since he receives and receives the accepted consequences unencumbered, and when he finds any annoyance that as soon as the whole of our affairs is and they are a thing, it will happen to the architect",
        postId: 1,
        postTitle: "great but easy",
        userId: 1,
      ),
      PostModel(
        postBody:
            "since he receives and receives the accepted consequences unencumbered, and when he finds any annoyance that as soon as the whole of our affairs is and they are a thing, it will happen to the architect",
        postId: 2,
        postTitle: "great but easy",
        userId: 2,
      ),
    ];
    List<PostEntity> postEntity = posts;

    HttpException e = HttpException(kServerError);

    test(
      "Should return remote data when the call to remote data is success:",
      () async {
        when(() => mockPostRemoteDataSource.getAllPosts())
            .thenAnswer((_) async => posts);

        final result = await postRepositoryImplementation.getPostsFromApi();

        expect(
          result,
          equals(
            Right(postEntity),
          ),
        );
      },
    );

    test(
      "Should return server exception data when the call to remote data is unsuccess:",
      () async {
        when(() => mockPostRemoteDataSource.getAllPosts())
            .thenThrow(HttpException(''));

        final result = await postRepositoryImplementation.getPostsFromApi();

        verify(() => mockPostRemoteDataSource.getAllPosts());
        expect(
          result,
          equals(
            Left(HttpException('')),
          ),
        );
      },
    );
  });
}
