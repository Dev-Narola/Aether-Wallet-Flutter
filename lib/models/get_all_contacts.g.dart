// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllContacts _$GetAllContactsFromJson(Map<String, dynamic> json) =>
    GetAllContacts(
      contacts: (json['contacts'] as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllContactsToJson(GetAllContacts instance) =>
    <String, dynamic>{
      'contacts': instance.contacts,
    };

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['created_at'] as String,
      id: json['id'] as String,
      mobileNo: json['mobile_no'] as String,
      name: json['name'] as String,
      userImage: json['user_image'] as String,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'amount': instance.amount,
      'created_at': instance.createdAt,
      'id': instance.id,
      'mobile_no': instance.mobileNo,
      'name': instance.name,
      'user_image': instance.userImage,
    };
