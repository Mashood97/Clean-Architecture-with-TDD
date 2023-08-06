import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../exception/response_error.dart';

part 'api_result.freezed.dart';

@freezed
class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success({@required T? data}) = Success<T>;

  const factory ApiResult.failure({@required ResponseError? error}) =
      Failure<T>;
}
