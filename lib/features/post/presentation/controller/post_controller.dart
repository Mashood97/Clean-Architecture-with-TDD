import 'package:dartz/dartz.dart';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/articles/domain/entities/article.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/entities/post_entity.dart';
import 'package:flutter_api_clean_architecture/features/post/domain/usecases/get_posts_usecase.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PostController extends GetxController {
  final GetPostUseCase postUseCase;
  PostController({required this.postUseCase});

  final RxList<PostEntity> _posts = RxList();

  List<PostEntity> get posts => [..._posts];

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  setIsLoading(bool val) {
    _isLoading.value = val;
    update();
  }

  Future getPosts() async {
    setIsLoading(true);
    final Either<Failure, List<PostEntity>> response =
        await postUseCase.postRepository.getAllPostFromApi();

    response.fold((failure) => Get.snackbar("Error", failure.toString()),
        (postList) => _posts.addAll(postList));

    setIsLoading(false);
  }

  // String _mapFailureToMessage(Failure failure) {
  //   // switch (failure.runtimeType) {
  //   //   case ServerFailure:
  //   //     return SERVER_FAILURE_MESSAGE;
  //   //   case CacheFailure:
  //   //     return CACHE_FAILURE_MESSAGE;
  //   //   default:
  //   //     return 'Unexpected error';
  //   // }
  //   if (failure.runtimeType == RemoteFailure) {
  //     return failure.props;
  //   } else {
  //     return 'Unexpected error';
  //   }
  // }

  @override
  void onInit() async {
    await getPosts();

    super.onInit();
  }
}
