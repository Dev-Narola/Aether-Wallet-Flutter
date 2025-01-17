// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryRequest _$CategoryRequestFromJson(Map<String, dynamic> json) =>
    CategoryRequest(
      json['name'] as String,
      json['type'] as String,
      json['icon'] as String,
      json['color'] as String,
    );

Map<String, dynamic> _$CategoryRequestToJson(CategoryRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'icon': instance.icon,
      'color': instance.color,
    };
