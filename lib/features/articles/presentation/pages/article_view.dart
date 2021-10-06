import 'package:flutter/material.dart';
import 'package:flutter_api_clean_architecture/features/articles/presentation/controller/article_controller.dart';
import 'package:flutter_api_clean_architecture/utils/route/app_route.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class ArticleView extends StatelessWidget {
  ArticleView({Key? key}) : super(key: key);

  final _controller = Get.find<ArticleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
      ),
      body: SafeArea(
        child: Obx(
          () => _controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (ctx, index) => ListTile(
                    title: Text(_controller.articles[index].title),
                  ),
                  itemCount: _controller.articles.length,
                ),
        ),
      ),
    );
  }
}
