// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupRequest _$SignupRequestFromJson(Map<String, dynamic> json) =>
    SignupRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      mobile_no: json['mobile_no'] as String,
      password: json['password'] as String,
      user_image: json['user_image'] as String,
    );

Map<String, dynamic> _$SignupRequestToJson(SignupRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'mobile_no': instance.mobile_no,
      'password': instance.password,
      'user_image': instance.user_image,
    };
