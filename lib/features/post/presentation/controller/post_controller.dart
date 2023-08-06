import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/usecases/get_posts_usecase.dart';
import 'package:get/get.dart';

import '../../../../utils/chopper_client/exception/response_error.dart';

class PostController extends GetxController {
  final GetPostsUseCase postsUseCase;

  PostController({required this.postsUseCase});

  final RxList<PostEntity> _posts = RxList();

  List<PostEntity> get posts => [..._posts];

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  setIsLoading(bool val) {
    _isLoading.value = val;
    update();
  }

  Future getAllPosts() async {
    setIsLoading(true);

    final Either<ResponseError, List<PostEntity>> response =
        await postsUseCase.postRepository.getPostsFromApi();
    response
        .fold((failure) => Get.snackbar("Error", failure.errorStatus),
            (postList) {
      _posts.addAll(postList);
    });

    setIsLoading(false);
  }

 
  @override
  void onInit() async {
    await getAllPosts();

    super.onInit();
  }
}
