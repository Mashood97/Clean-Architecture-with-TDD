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
//---------------USE CASES-------------
  Get.lazyPut<GetArticlesUseCase>(() =>
      GetArticlesUseCase(articleRepository: Get.find<ArticleRepository>()));
  Get.lazyPut<GetSingleArticleUseCase>(() => GetSingleArticleUseCase(
      articleRepository: Get.find<ArticleRepository>()));

//---------------Repositories-------------

  Get.lazyPut<ArticleRepository>(
    () => ArticleRepositoryImplementation(
      localSource: Get.find<ArticleLocalDataSourceRepository>(),
      networkInfo: Get.find<NetworkInfo>(),
      remoteSource: Get.find<ArticleRemoteDataSourceRepository>(),
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

//External packages: (Firebase,Connectivity or Internet connection checker etc).

  Get.lazyPut<NetworkInfo>(
    () => NetworkInfoImpl(
      internetConnectionChecker: Get.find<InternetConnectionChecker>(),
    ),
  );

  final pref = await SharedPreferences.getInstance();

  Get.lazyPut<SharedPreferences>(() => pref);

  Get.lazyPut<Dio>(() => Dio());
  Get.lazyPut<InternetConnectionChecker>(() => InternetConnectionChecker());
}
