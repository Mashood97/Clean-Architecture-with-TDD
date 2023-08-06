import 'dart:async';
import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectionInterceptor extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    log("CALLED INTERNET ${request.url}");
    final connection = await InternetConnectionChecker().hasConnection;
    if (connection == false) {
      throw NoInternetConnectionException();
    }
    return request;
  }
}

class NoInternetConnectionException implements Exception {
  final String message =
      "No Internet connection available, please try again later.";

  @override
  String toString() {
    return message;
  }
}
