import 'package:aether_wallet/models/get_all_contacts.dart';
import 'package:json_annotation/json_annotation.dart';
part 'contact_response.g.dart';

@JsonSerializable()
class ContectResponse {
  @JsonKey(name: "contact")
  Contact contact;

  ContectResponse({
    required this.contact,
  });

  factory ContectResponse.fromJson(Map<String, dynamic> json) =>
      _$ContectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContectResponseToJson(this);
}
