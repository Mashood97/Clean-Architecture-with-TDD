import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_api_clean_architecture/features/post/data/repositories/post_repo_impl.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRemoteDataSource extends Mock
    implements PostRemoteDataSourceRepository {}

void main() {
  late PostRepoImpl postRepoImpl;
  late MockPostRemoteDataSource mockPostRemoteDataSource;

  setUp(() {
    mockPostRemoteDataSource = MockPostRemoteDataSource();
    postRepoImpl =
        PostRepoImpl(postRemoteDataSourceRepository: mockPostRemoteDataSource);
  });

  group("Should get all posts", () {
    List<PostModel> posts = const [
      PostModel(userId: 1, postId: 1, title: "test", body: "test"),
      PostModel(userId: 1, postId: 2, title: "test", body: "test"),
    ];
    List<PostEntity> postEntity = posts;

    test(
      "Should return remote data when the call to remote data is success:",
      () async {
        when(() => mockPostRemoteDataSource.getPostsFromServer())
            .thenAnswer((_) async => posts);

        final result = await postRepoImpl.getAllPostFromApi();

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
        when(() => mockPostRemoteDataSource.getPostsFromServer())
            .thenThrow(ServerException());

        final result = await postRepoImpl.getAllPostFromApi();

        verify(() => mockPostRemoteDataSource.getPostsFromServer());
        // verifyZeroInteractions(mockArticleLocalDataSource);
        expect(
          result,
          equals(
            Left(ServerFailure()),
          ),
        );
      },
    );
  });
}
