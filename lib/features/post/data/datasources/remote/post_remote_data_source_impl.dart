import 'dart:convert';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_chopper_service.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_api_clean_architecture/utils/constant/api.dart';

import '../../../../../utils/chopper_client/chopper_client.dart';
import '../../../../../utils/chopper_client/exception/response_error.dart';

class PostRemoteDataSourceRepoImpl implements PostRemoteDataSource {
  final postService = PostChopperService.create(ChopperClientInstance.client);

  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      final response = await postService.getAllPosts();
      if (response.isSuccessful) {
        final body = response.bodyString;
        final decodedBody = jsonDecode(body) as List<dynamic>;
        List<PostModel> _posts = [];
        for (var json in decodedBody) {
          _posts.add(PostModel.fromJson(json));
        }

        return _posts;
      }
      return [];
    } on ResponseError catch (e) {
      throw e.errorStatus;
    }
  }
}
