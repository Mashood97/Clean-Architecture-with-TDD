import 'package:flutter/material.dart';
import 'package:flutter_api_clean_architecture/features/articles/presentation/controller/article_controller.dart';
import 'package:flutter_api_clean_architecture/utils/route/app_route.dart';
import 'package:get/instance_manager.dart';

class ArticleView extends StatelessWidget {
  ArticleView({Key? key}) : super(key: key);

  final _controller = Get.find<ArticleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text('Goto next screen'),
        onPressed: () {
          AppRoute.navigateToSingleArticle(1);
        },
      ),
    ));
  }
}
