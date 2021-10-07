import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
}
