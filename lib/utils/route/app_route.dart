import 'package:get/get.dart';

class PageConstant {
  static const String articles = '/articles';
  static const String articleById = '/single-article';
}

class AppRoute {
  static void navigateToSingleArticle(var arguments) {
    Get.toNamed(PageConstant.articleById, arguments: arguments);
  }
}
