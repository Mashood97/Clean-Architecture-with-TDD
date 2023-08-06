import 'package:json_annotation/json_annotation.dart';

part 'dummy_model.g.dart';

@JsonSerializable()
class Resource {
  final String id;
  final String name;

  Resource(this.id, this.name);

  static const fromJsonFactory =
      _$ResourceFromJson; //this should be added in all models.

  Map<String, dynamic> toJson() => _$ResourceToJson(this);

  @override
  String toString() => 'Resource{id: $id, name: $name}';
}
