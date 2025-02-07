// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:aether_wallet/view/home/widget/transiction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewAllReportScreen extends StatefulWidget {
  final List<Report> reports;
  const ViewAllReportScreen({super.key, required this.reports});

  @override
  State<ViewAllReportScreen> createState() => _ViewAllReportScreenState();
}

class _ViewAllReportScreenState extends State<ViewAllReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        centerTitle: true,
        title: ReusableText(
          text: "View all report",
          fontSize: 22.sp,
          color: headingText,
          fontWeight: FontWeight.bold,
          letterSpace: 1.5,
        ),
        automaticallyImplyLeading: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.0.w),
          child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: headingText,
              )),
        ),
        backgroundColor: lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: widget.reports.isEmpty
          ? Center(
              child: ReusableText(
                text: "No report available",
                fontSize: 20.sp,
                color: headingText,
                fontWeight: FontWeight.bold,
              ),
            )
          : Padding(
              padding:
                  EdgeInsets.only(left: 14.0.w, right: 14.0.w, top: 14.0.w),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: ListView.builder(
                  itemCount:
                      widget.reports.length > 5 ? 5 : widget.reports.length,
                  itemBuilder: (context, index) {
                    final Report report = widget.reports[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.0.h),
                      child: TransictionTile(report: report),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
