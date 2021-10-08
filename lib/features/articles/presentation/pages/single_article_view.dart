import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/single_article_controller.dart';

class SingleArticleView extends StatelessWidget {
  SingleArticleView({Key? key}) : super(key: key);

  final _controller = Get.find<SingleArticleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Article View'),
      ),
      body: SafeArea(
        child: Center(
          child: Obx(
            () => _controller.isLoading
                ? const CircularProgressIndicator()
                : Text(_controller.article.title),
          ),
        ),
      ),
    );
  }
}
