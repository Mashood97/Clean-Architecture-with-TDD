import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/repositories/post_repository.dart';

class PostRepoImpl implements PostRepository {
  final PostRemoteDataSourceRepository postRemoteDataSourceRepository;

  PostRepoImpl({required this.postRemoteDataSourceRepository});
  @override
  Future<Either<Failure, List<PostEntity>>> getAllPostFromApi() async {
    try {
      return Right(await postRemoteDataSourceRepository.getPostsFromServer());
    } on RemoteException catch (exception) {
      return Left(RemoteFailure(
          message: exception.dioError.message,
          errorType: exception.dioError.type));
    }
  }
}
