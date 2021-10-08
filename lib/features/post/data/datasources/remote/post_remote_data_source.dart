import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_api_clean_architecture/utils/constant/api.dart';
import 'package:flutter_api_clean_architecture/utils/networking/client.dart';

abstract class PostRemoteDataSourceRepository {
  Future<List<PostModel>> getPostsFromServer();
}

class PostRemoteDataSourceRepositoryImplementation
    implements PostRemoteDataSourceRepository {
  final NetworkClient dio;

  PostRemoteDataSourceRepositoryImplementation({required this.dio});
  @override
  Future<List<PostModel>> getPostsFromServer() async {
    try {
      Response response = await dio.get(
        '${Api.baseUrl}${Api.post}',
      );

      final List<PostModel> _posts = [];

      var decode = response.data;
      //Whenever For testing add json decoded
      // var decode = json.decode(response.data);
      for (var article in decode) {
        _posts.add(PostModel.fromJson(article));
      }

      return Future.value(_posts);
    } on RemoteException catch (exception) {
      throw exception;
    }
  }
}
