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
              : ListView.separated(
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (ctx, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        _postController.posts[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        _postController.posts[index].body,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  itemCount: _postController.posts.length,
                ),
        ),
      ),
    );
  }
}
