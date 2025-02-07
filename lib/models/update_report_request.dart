// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'update_report_request.g.dart';

@JsonSerializable()
class UpdateReportRequest {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "merchant_name")
  String merchantName;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "date")
  String date;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "category")
  String category;
  @JsonKey(name: "amount")
  double amount;
  @JsonKey(name: "bill_image")
  String billImage;

  UpdateReportRequest({
    required this.id,
    required this.title,
    required this.merchantName,
    required this.description,
    required this.date,
    required this.type,
    required this.category,
    required this.amount,
    required this.billImage,
  });

  factory UpdateReportRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateReportRequestToJson(this);
}
