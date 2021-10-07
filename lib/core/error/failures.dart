import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List? properties = const <dynamic>[];
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.

  @override
  List<Object?> get props => [properties];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
