import 'dart:convert';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_remote_data_source.dart';
import 'package:flutter_api_clean_architecture/features/post/data/models/post_model.dart';
import 'package:flutter_api_clean_architecture/utils/constant/api.dart';
import 'package:flutter_api_clean_architecture/utils/networking/http_exception.dart';
import 'package:flutter_api_clean_architecture/utils/networking/networking_handler.dart';
import 'package:get/get_connect.dart';

class PostRemoteDataSourceRepoImpl implements PostRemoteDataSource {
  final DioClient dioClient;
  PostRemoteDataSourceRepoImpl({
    required this.dioClient,
  });
  @override
  Future<List<PostModel>> getPostsFromApi() async {
    try {
      Response response = await dioClient.get(Api.post);
      List<PostModel> _posts = [];
      for (var json in json.decode(response.body)) {
        _posts.add(PostModel.fromJson(json));
      }
      return Future.value(_posts);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    }
  }
}
