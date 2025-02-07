// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:aether_wallet/view/home/widget/update_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  final categories;
  Report report;
  ReportScreen({super.key, required this.report, required this.categories});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: ReusableText(
          text: "Report",
          fontSize: 20.sp,
          color: headingText,
          fontWeight: FontWeight.bold,
          letterSpace: 1.3,
        ),
        centerTitle: true,
        backgroundColor: appBar,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.w),
          child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                LineIcons.arrowLeft,
                color: headingText,
              )),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Row(
              children: [
                ReusableText(
                  text: "Title",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.3,
                ),
                Spacer(),
                ReusableText(
                  text: widget.report.title,
                  fontSize: 17.sp,
                  letterSpace: 1.3,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                ReusableText(
                  text: "Merchant Name",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.3,
                ),
                Spacer(),
                ReusableText(
                  text: widget.report.merchantName,
                  fontSize: 17.sp,
                  letterSpace: 1.3,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                ReusableText(
                  text: "Description",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.3,
                ),
                Spacer(),
                ReusableText(
                  text: widget.report.description,
                  fontSize: 17.sp,
                  letterSpace: 1.3,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                ReusableText(
                  text: "Date",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.3,
                ),
                Spacer(),
                ReusableText(
                  text: widget.report.date,
                  fontSize: 17.sp,
                  letterSpace: 1.3,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                ReusableText(
                  text: "Report Type",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.3,
                ),
                Spacer(),
                ReusableText(
                  text: widget.report.reportType,
                  fontSize: 17.sp,
                  letterSpace: 1.3,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                ReusableText(
                  text: "Category",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.3,
                ),
                Spacer(),
                ReusableText(
                  text: widget.report.categories.name,
                  fontSize: 17.sp,
                  letterSpace: 1.3,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                ReusableText(
                  text: "Amount",
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.3,
                ),
                Spacer(),
                ReusableText(
                  text: widget.report.amount.toString(),
                  fontSize: 17.sp,
                  letterSpace: 1.3,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            DottedBorder(
                dashPattern: [5],
                borderType: BorderType.RRect,
                radius: Radius.circular(10.r),
                strokeWidth: 1.5,
                child: Container(
                  color: Colors.white,
                  height: 175,
                  width: double.infinity,
                  child: Center(
                    child: Image.network(widget.report.billImage),
                  ),
                )),
            SizedBox(height: 16.h),
            ReusableButton(
                text: "Update Report",
                icon: LineIcons.arrowCircleRight,
                onTap: () {
                  Get.to(() => UpdateReport(
                        report: widget.report,
                        categories: widget.categories,
                      ));
                }),
            SizedBox(height: 14.h),
            ReusableButton(
              text: "Delete Report",
              icon: LineIcons.trash,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = await prefs.getString("token");
                String finalToken = "Bearer $token";

                restClient
                    .deleteReport(finalToken, widget.report.id)
                    .then((response) {
                  Get.snackbar(
                    "Success",
                    "Report deleted successfully",
                    backgroundColor: success,
                    colorText: headingText,
                  );
                  Get.to(() => BottomNavigationBarr());
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
