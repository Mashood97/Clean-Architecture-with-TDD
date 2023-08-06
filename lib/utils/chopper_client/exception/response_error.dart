import 'package:json_annotation/json_annotation.dart';

part 'response_error.g.dart';

@JsonSerializable()
class ResponseError {
  @JsonKey(name: "message")
  final String errorStatus;

  ResponseError({
    required this.errorStatus,
  });

  Map<String, dynamic> toJson() => _$ResponseErrorToJson(this);

  static const fromJsonFactory = _$ResponseErrorFromJson;
}
