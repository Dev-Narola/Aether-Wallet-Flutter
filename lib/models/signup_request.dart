// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'signup_request.g.dart';

@JsonSerializable()
class SignupRequest {
  final String name;
  final String email;
  final String mobile_no;
  final String password;
  final String user_image;

  SignupRequest({
    required this.name,
    required this.email,
    required this.mobile_no,
    required this.password,
    required this.user_image,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}
