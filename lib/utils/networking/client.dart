import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_api_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_api_clean_architecture/utils/constant/api.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;
const kServerError =
    'The server encountered an internal error and unable to process your request.';
const kRedirectionError = 'The resource requested has been temporarily moved.';
const kBadRequestError =
    'Your client has issued a malformed or illegal request.';
const kInternetError =
    'There is poor or no internet connection, please try again later.';

class NetworkClient {
  late Dio _dio;
  final List<Interceptor>? interceptors;

  NetworkClient(
    Dio dio, {
    this.interceptors,
  }) {
    _dio = dio;
    _dio!
      ..options.baseUrl = Api.baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'}
      ..httpClientAdapter;

    if (interceptors?.isNotEmpty ?? false) {
      _dio!.interceptors.addAll(interceptors!);
    }
    if (kDebugMode) {
      _dio!.interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: true,
          request: true,
          requestBody: true));
    }
  }

  // for HTTP.GET Request.
  Future<Response> get(
    String? uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response response;
    try {
      // response = await _dio.get(url,
      //     queryParameters: params,
      //     options: Options(responseType: ResponseType.json));
      response = await _dio.get(
        uri!,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }

  // for HTTP.POST Request.
  Future<Response> post(String url, Map<String, String> params) async {
    Response response;
    try {
      response = await _dio.post(url,
          data: params, options: Options(responseType: ResponseType.json));
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }

  // for HTTP.PATCH Request.
  Future<Response> patch(String url, Map<String, String> params) async {
    Response response;
    try {
      response = await _dio.patch(url,
          data: params, options: Options(responseType: ResponseType.json));
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }
}
