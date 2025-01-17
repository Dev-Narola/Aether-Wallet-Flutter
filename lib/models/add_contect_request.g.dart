// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_contect_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddContectRequest _$AddContectRequestFromJson(Map<String, dynamic> json) =>
    AddContectRequest(
      name: json['name'] as String,
      mobileNo: json['mobile_no'] as String,
      userImage: json['user_image'] as String,
    );

Map<String, dynamic> _$AddContectRequestToJson(AddContectRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mobile_no': instance.mobileNo,
      'user_image': instance.userImage,
    };
