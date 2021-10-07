import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/usecases/usecase_post.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/repositories/post_repository.dart';
import 'package:flutter_api_clean_architecture/utils/networking/http_exception.dart';

class GetPostsUseCase extends UseCase<List<PostEntity>, NoParams> {
  final PostRepository postRepository;
  GetPostsUseCase({required this.postRepository});
  @override
  Future<Either<HttpException, List<PostEntity>>> call(NoParams params) =>
      postRepository.getPostsFromApi();
}
