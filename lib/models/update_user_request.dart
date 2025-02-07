// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';

@JsonSerializable()
class UpdateUserRequest {
  final String name;
  final String email;
  final String mobile_no;
  final String password;
  final String user_image;

  UpdateUserRequest({
    required this.name,
    required this.email,
    required this.mobile_no,
    required this.password,
    required this.user_image,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}
