//using GetIt

//Using Getx
import 'package:dio/dio.dart';
import 'package:flutter_api_clean_architecture/core/platform/network_info.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/datasources/local/article_local_data_source_repo.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/datasources/remote/article_remote_data_source_repository.dart';
import 'package:flutter_api_clean_architecture/features/articles/data/repositories/article_repository_impl.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/repositories/article_repository.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/usecases/get_single_article_usecase.dart';
import 'package:flutter_api_clean_architecture/features/articles/presentation/controller/article_controller.dart';
import 'package:flutter_api_clean_architecture/features/articles/presentation/controller/single_article_controller.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/data/repositories/post_repo_impl.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/repositories/post_repository.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_api_clean_architecture/features/post/presentation/controller/post_controller.dart';
import 'package:flutter_api_clean_architecture/utils/networking/client.dart';

import 'package:flutter_api_clean_architecture/utils/networking/networking_handler.dart';
import 'package:get/instance_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeDependencies() async {
//---------------BLOC OR CONTROLLERS-------------

//Fenix means permenantely available in memory to have instances
  Get.lazyPut<ArticleController>(
      () => ArticleController(
          getArticlesUseCase: Get.find<GetArticlesUseCase>(),
          getSingleArticleUseCase: Get.find<GetSingleArticleUseCase>()),
      fenix: true);
  Get.lazyPut<SingleArticleController>(
      () => SingleArticleController(
          getArticlesUseCase: Get.find<GetArticlesUseCase>(),
          getSingleArticleUseCase: Get.find<GetSingleArticleUseCase>()),
      fenix: true);

  Get.lazyPut<PostController>(
      () => PostController(
            postUseCase: Get.find<GetPostUseCase>(),
          ),
      fenix: true);
//---------------USE CASES-------------
  Get.lazyPut<GetArticlesUseCase>(() =>
      GetArticlesUseCase(articleRepository: Get.find<ArticleRepository>()));
  Get.lazyPut<GetSingleArticleUseCase>(() => GetSingleArticleUseCase(
      articleRepository: Get.find<ArticleRepository>()));

  Get.lazyPut<GetPostUseCase>(
      () => GetPostUseCase(postRepository: Get.find<PostRepository>()));

//---------------Repositories-------------

  Get.lazyPut<ArticleRepository>(
    () => ArticleRepositoryImplementation(
      localSource: Get.find<ArticleLocalDataSourceRepository>(),
      networkInfo: Get.find<NetworkInfo>(),
      remoteSource: Get.find<ArticleRemoteDataSourceRepository>(),
    ),
  );

  Get.lazyPut<PostRepository>(
    () => PostRepoImpl(
      postRemoteDataSourceRepository:
          Get.find<PostRemoteDataSourceRepository>(),
    ),
  );

//---------------Data Sources-------------

  Get.lazyPut<ArticleLocalDataSourceRepository>(
    () => ArticleLocalDataSourceImpl(
      sharedPreferences: Get.find<SharedPreferences>(),
    ),
  );
  Get.lazyPut<ArticleRemoteDataSourceRepository>(
    () => ArticleRemoteDataSourceImpl(dio: Get.find<Dio>()),
  );

  Get.lazyPut<PostRemoteDataSourceRepository>(
    () => PostRemoteDataSourceRepositoryImplementation(
        dio: Get.find<NetworkClient>()),
  );

//External packages: (Firebase,Connectivity or Internet connection checker etc).

  Get.lazyPut<NetworkInfo>(
    () => NetworkInfoImpl(
      internetConnectionChecker: Get.find<InternetConnectionChecker>(),
    ),
  );

  final pref = await SharedPreferences.getInstance();

  Get.lazyPut<SharedPreferences>(() => pref);
  Get.lazyPut<DioClient>(() => DioClient(Get.find<Dio>()));
  Get.lazyPut<NetworkClient>(() => NetworkClient(Get.find<Dio>()));

  Get.lazyPut<Dio>(() => Dio());
  Get.lazyPut<InternetConnectionChecker>(() => InternetConnectionChecker());
}
