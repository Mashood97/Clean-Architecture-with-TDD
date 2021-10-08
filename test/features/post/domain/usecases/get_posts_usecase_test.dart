import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/repositories/post_repository.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepo extends Mock implements PostRepository {}

void main() {
  late final MockPostRepo postRepo;
  late final GetPostUseCase postUseCase;

  setUp(() {
    postRepo = MockPostRepo();
    postUseCase = GetPostUseCase(postRepository: postRepo);
  });

  List<PostEntity> posts = const [
    PostEntity(userId: 1, postId: 1, title: "test", body: "test"),
    PostEntity(userId: 1, postId: 2, title: "test", body: "test"),
  ];

  test("should get all articles from remote repo", () async {
    when(() => postRepo.getAllPostFromApi())
        .thenAnswer((_) async => Right(posts));

    final result = await postUseCase(NoParams());

    expect(result, Right(posts));

    verify(() => postRepo.getAllPostFromApi());

    verifyNoMoreInteractions(postRepo);
  });
}
