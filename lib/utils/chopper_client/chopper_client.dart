import 'package:chopper/chopper.dart';
import 'package:flutter_api_clean_architecture/features/post/data/datasources/remote/post_chopper_service.dart';

import '../constant/api.dart';
import 'converter/json_serializable_converter.dart';
import 'dummy_model.dart';
import 'interceptor/header_interceptor.dart';
import 'interceptor/internet_connection_interceptor.dart';

class ChopperClientInstance {
  static final ChopperClientInstance _singleton =
      ChopperClientInstance._internal();

  factory ChopperClientInstance() {
    return _singleton;
  }

  ChopperClientInstance._internal();

  static const converter = JsonSerializableConverter({
    Resource: Resource.fromJsonFactory,
  });

  static ChopperClient? client;

  static void initializeChopperClient() {
    client ??= ChopperClient(
        baseUrl: Uri.parse(Api.baseUrl),
        services: [
          // Create and pass an instance of the generated service to the client
          PostChopperService.create(),
        ],
        converter: converter,
        errorConverter: converter,
        interceptors: [
          InternetConnectionInterceptor(),
          HeaderInterceptor(),
          HttpLoggingInterceptor(),
        ]);
  }
}
