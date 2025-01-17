// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransectionsRequest _$TransectionsRequestFromJson(Map<String, dynamic> json) =>
    TransectionsRequest(
      contactId: json['contact_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$TransectionsRequestToJson(
        TransectionsRequest instance) =>
    <String, dynamic>{
      'contact_id': instance.contactId,
      'amount': instance.amount,
      'type': instance.type,
      'description': instance.description,
    };
