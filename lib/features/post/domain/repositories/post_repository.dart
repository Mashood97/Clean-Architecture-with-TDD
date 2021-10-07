import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/utils/networking/http_exception.dart';

abstract class PostRepository {
  Future<Either<HttpFailure, List<PostEntity>>> getPostsFromApi();
}
