import 'package:chopper/chopper.dart';
import 'package:flutter_api_clean_architecture/utils/constant/api.dart';


part "post_chopper_service.chopper.dart";

@ChopperApi(baseUrl: Api.post)
abstract class PostChopperService extends ChopperService {
  static PostChopperService create([ChopperClient? client]) =>
      _$PostChopperService(client);


  @Get()
  Future<Response<Map>> getAllPosts();
}

