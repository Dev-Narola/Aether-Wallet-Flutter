import 'package:json_annotation/json_annotation.dart';
part 'get_all_contacts.g.dart';

@JsonSerializable()
class GetAllContacts {
  @JsonKey(name: "contacts")
  List<Contact> contacts;

  GetAllContacts({
    required this.contacts,
  });

  factory GetAllContacts.fromJson(Map<String, dynamic> json) =>
      _$GetAllContactsFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllContactsToJson(this);
}

@JsonSerializable()
class Contact {
  @JsonKey(name: "amount")
  double amount; // Make it nullable
  @JsonKey(name: "created_at")
  String createdAt;
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "mobile_no")
  String mobileNo;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "user_image")
  String userImage;

  Contact({
    required this.amount, // Allow it to be null
    required this.createdAt,
    required this.id,
    required this.mobileNo,
    required this.name,
    required this.userImage,
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
