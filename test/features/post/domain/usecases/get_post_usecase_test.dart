import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/usecases/usecase_post.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/repositories/post_repository.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPostsUseCase postsUseCase;
  late MockPostRepository repository;

  setUp(() {
    repository = MockPostRepository();
    postsUseCase = GetPostsUseCase(postRepository: repository);
  });

  List<PostEntity> posts = const [
    PostEntity(
      postBody:
          "since he receives and receives the accepted consequences unencumbered, and when he finds any annoyance that as soon as the whole of our affairs is and they are a thing, it will happen to the architect",
      postId: 1,
      postTitle: "great but easy",
      userId: 1,
    ),
    PostEntity(
      postBody:
          "since he receives and receives the accepted consequences unencumbered, and when he finds any annoyance that as soon as the whole of our affairs is and they are a thing, it will happen to the architect",
      postId: 2,
      postTitle: "great but easy",
      userId: 2,
    ),
  ];

  test("Should get all posts from server", () async {
    when(() => repository.getPostsFromApi())
        .thenAnswer((_) async => Right(posts));

    final result = await postsUseCase(NoParams());

    expect(result, Right(posts));
    verify(() => repository.getPostsFromApi());
    verifyNoMoreInteractions(repository);
  });
}
