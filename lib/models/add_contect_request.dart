import 'package:json_annotation/json_annotation.dart';
part 'add_contect_request.g.dart';

@JsonSerializable()
class AddContectRequest {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "mobile_no")
  String mobileNo;
  @JsonKey(name: "user_image")
  String userImage;

  AddContectRequest({
    required this.name,
    required this.mobileNo,
    required this.userImage,
  });

  factory AddContectRequest.fromJson(Map<String, dynamic> json) =>
      _$AddContectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddContectRequestToJson(this);
}
