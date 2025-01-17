// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddReportRequest _$AddReportRequestFromJson(Map<String, dynamic> json) =>
    AddReportRequest(
      title: json['title'] as String,
      merchantName: json['merchant_name'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      billImage: json['bill_image'] as String,
    );

Map<String, dynamic> _$AddReportRequestToJson(AddReportRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'merchant_name': instance.merchantName,
      'description': instance.description,
      'date': instance.date,
      'type': instance.type,
      'category': instance.category,
      'amount': instance.amount,
      'bill_image': instance.billImage,
    };
