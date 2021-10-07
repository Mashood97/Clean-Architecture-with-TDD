import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/repositories/post_repository.dart';
import 'package:flutter_api_clean_architecture/utils/networking/http_exception.dart';

class PostRepoImpl implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;

  PostRepoImpl({required this.postRemoteDataSource});
  @override
  Future<Either<HttpFailure, List<PostEntity>>> getPostsFromApi() async {
    try {
      var posts = await postRemoteDataSource.getAllPosts();
      return Right(posts);
    } on HttpException catch (e){
      return Left(HttpFailure(e.message));
    }
  }
}
