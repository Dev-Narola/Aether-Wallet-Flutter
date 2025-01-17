import 'package:json_annotation/json_annotation.dart';

part 'category_request.g.dart';

@JsonSerializable()
class CategoryRequest {
  final String name;
  final String type;
  final String icon;
  final String color;

  CategoryRequest(this.name, this.type, this.icon, this.color);

  factory CategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CategoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryRequestToJson(this);
}
