import 'package:flutter/material.dart';
import 'package:flutter_api_clean_architecture/features/articles/presentation/controller/article_controller.dart';
import 'package:get/instance_manager.dart';

class ArticleView extends StatelessWidget {
  ArticleView({Key? key}) : super(key: key);

  final _controller = Get.find<ArticleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
