import 'dart:convert';
import 'package:flutter_api_clean_architecture/core/error/failures.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_api_clean_architecture/utils/constant/api.dart';
import 'package:flutter_api_clean_architecture/utils/networking/http_exception.dart';
import 'package:flutter_api_clean_architecture/utils/networking/networking_handler.dart';

class PostRemoteDataSourceRepoImpl implements PostRemoteDataSource {
  final DioClient dioClient;
  PostRemoteDataSourceRepoImpl({
    required this.dioClient,
  });
  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      final response = await dioClient.get(Api.post);
      List<PostModel> _posts = [];
      for (var json in response) {
        _posts.add(PostModel.fromJson(json));
      }
      return Future.value(_posts);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    }
  }
}
