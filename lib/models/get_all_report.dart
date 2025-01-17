// import 'package:aether_wallet/models/categories_response.dart';

// class GetAllReport {
//   List<Report>? reports;

//   GetAllReport({this.reports});

//   factory GetAllReport.fromJson(Map<String, dynamic> json) {
//     return GetAllReport(
//       reports:
//           json['reports'] != null
//               ? List<Report>.from(
//                 json['reports'].map((x) => Report.fromJson(x)),
//               )
//               : [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'reports': reports?.map((x) => x.toJson()).toList()};
//   }
// }

class ReportsResponse {
  List<Report> reports;

  ReportsResponse({required this.reports});

  factory ReportsResponse.fromJson(Map<String, dynamic> json) {
    return ReportsResponse(
      reports: List<Report>.from(
        json['reports'].map((x) => Report.fromJson(x)),
      ),
    );
  }
}

class Report {
  String id;
  double amount;
  String title;
  String merchantName;
  String description;
  String reportType;
  String date;
  String createdAt;
  String billImage;
  Categories categories;

  Report({
    required this.id,
    required this.amount,
    required this.title,
    required this.merchantName,
    required this.description,
    required this.reportType,
    required this.date,
    required this.createdAt,
    required this.billImage,
    required this.categories,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      amount: json['amount'],
      title: json['title'],
      merchantName: json['merchant_name'],
      description: json['description'],
      reportType: json['report_type'],
      date: json['date'],
      createdAt: json['created_at'],
      billImage: json['bill_image'],
      categories: Categories.fromJson(json['category']),
    );
  }
}

class Categories {
  String id;
  String name;
  String type;
  String icon;

  Categories({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
    );
  }
}
