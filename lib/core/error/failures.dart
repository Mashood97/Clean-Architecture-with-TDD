import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_api_clean_architecture/utils/networking/http_exception.dart';

// abstract class Failure extends Equatable {
//   final List? properties = const <dynamic>[];
//   // If the subclasses have some properties, they'll get passed to this constructor
//   // so that Equatable can perform value comparison.

//   @override
//   List<Object?> get props => [properties];
// }

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];

  const Failure([List properties = const <dynamic>[]]) : super();
}

class RemoteFailure extends Failure {
  final String message;
  final DioErrorType errorType;

  const RemoteFailure({required this.message, required this.errorType});

  @override
  List<Object> get props => [message, errorType];
}

// Represent failures from Cache.
class LocalFailure extends Failure {
  final String message;
  final int error;

  const LocalFailure({required this.message, required this.error});
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class ServerFailures extends Failure {
  final dynamic error;

  const ServerFailures({required this.error});

  @override
  List<Object> get props => [error];
}

class CacheFailures extends Failure {
  final dynamic error;

  CacheFailures({required this.error});

  @override
  List<Object> get props => [error];
}

class AnotherFailures extends Failure {
  final dynamic error;

  AnotherFailures({required this.error});

  @override
  List<Object> get props => [error];
}
