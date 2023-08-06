import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/core/usecases/usecase_post.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/repositories/post_repository.dart';

import '../../../../utils/chopper_client/exception/response_error.dart';

class GetPostsUseCase extends UseCase<List<PostEntity>, NoParams> {
  final PostRepository postRepository;
  GetPostsUseCase({required this.postRepository});
  @override
  Future<Either<ResponseError, List<PostEntity>>> call(NoParams params) async =>
      await postRepository.getPostsFromApi();
}
