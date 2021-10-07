import 'package:flutter/material.dart';
import 'package:flutter_api_clean_architecture/features/post/presentation/controller/post_controller.dart';
import 'package:get/get.dart';

class PostView extends StatelessWidget {
  PostView({Key? key}) : super(key: key);

  final _postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () => _postController.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _postController.posts.isEmpty
                  ? const Center(
                      child: Text('No Data found'),
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, index) => Center(
                        child: Text(_postController.posts[index].postBody),
                      ),
                      itemCount: _postController.posts.length,
                    ),
        ),
      ),
    );
  }
}
