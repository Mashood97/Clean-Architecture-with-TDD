import 'dart:async';
import 'package:chopper/chopper.dart';

class HeaderInterceptor implements RequestInterceptor {
  static const String authHeader = "Authorization";

  @override
  FutureOr<Request> onRequest(Request request) async => applyHeader(
        request,
        authHeader,
        "Bearer Token",
      );
}
