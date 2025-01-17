import 'package:json_annotation/json_annotation.dart';
part 'categories_response.g.dart';

@JsonSerializable()
class CategoriesResponse {
  @JsonKey(name: "categories")
  List<Category> categories;

  CategoriesResponse({required this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}

@JsonSerializable()
class Category {
  @JsonKey(name: "_id")
  String id;
  @JsonKey(name: "color")
  String color;
  @JsonKey(name: "icon")
  String icon;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "user_id")
  String userId;

  Category({
    required this.id,
    required this.color,
    required this.icon,
    required this.name,
    required this.type,
    required this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
