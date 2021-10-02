import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';

import '../../../../core/platform/network_info.dart';
import '../datasources/local/article_local_data_source_repo.dart';
import '../datasources/remote/article_remote_data_source_repository.dart';

import '../../domain/entities/article.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/article_repository.dart';

class ArticleRepositoryImplementation implements ArticleRepository {
  final ArticleRemoteDataSourceRepository remoteSource;
  final ArticleLocalDataSourceRepository localSource;
  final NetworkInfo networkInfo;
  ArticleRepositoryImplementation({
    required this.networkInfo,
    required this.remoteSource,
    required this.localSource,
  });

  @override
  Future<Either<Failure, Article>> getAllArticleById(int? articleId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(
          await remoteSource.getAllArticleById(articleId!),
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(
          await localSource.getAllArticleByIdFromLocal(articleId!),
        );
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getAllArticles() async {
    if (await networkInfo.isConnected) {
      try {
        var _remoteArticles = await remoteSource.getAllArticles();
        localSource.cacheAllArticles(_remoteArticles);
        return Right(_remoteArticles);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final _localArticles = await localSource.getAllArticlesFromLocal();
        return Right(_localArticles);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
