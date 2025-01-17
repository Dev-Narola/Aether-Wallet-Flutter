import 'package:json_annotation/json_annotation.dart';
part 'transaction_request.g.dart';

@JsonSerializable()
class TransectionsRequest {
  @JsonKey(name: "contact_id")
  String contactId;
  @JsonKey(name: "amount")
  double amount;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "description")
  String description;

  TransectionsRequest({
    required this.contactId,
    required this.amount,
    required this.type,
    required this.description,
  });

  factory TransectionsRequest.fromJson(Map<String, dynamic> json) =>
      _$TransectionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransectionsRequestToJson(this);
}
