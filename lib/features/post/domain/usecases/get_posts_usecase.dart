import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/repositories/post_repository.dart';

class GetPostUseCase extends UseCase<List<PostEntity>, NoParams> {
  final PostRepository postRepository;
  GetPostUseCase({required this.postRepository});
  @override
  Future<Either<Failure, List<PostEntity>>> call(NoParams params) async {
    return await postRepository.getAllPostFromApi();
  }
}
