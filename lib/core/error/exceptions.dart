import 'package:dio/dio.dart';

class ServerException implements Exception {}

class CacheException implements Exception {}

class FormatException implements Exception {}

class RemoteException implements Exception {
  DioError dioError;

  RemoteException({required this.dioError});
}
