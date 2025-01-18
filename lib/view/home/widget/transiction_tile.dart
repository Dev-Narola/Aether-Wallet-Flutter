// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/common/double_container.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransictionTile extends StatelessWidget {
  final Report report;
  const TransictionTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    Color amountColor = report.reportType == "Expense" ? Colors.red : success;
    return DoubleContainer(
      height: 90.h,
      width: 334.w,
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(report.billImage),
            ),
            SizedBox(width: 12.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: report.title,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  letterSpace: 1.5,
                ),
                SizedBox(height: 2.h),
                ReusableText(
                  text: report.categories.name,
                  fontSize: 13.sp,
                  letterSpace: 1.5,
                ),
                SizedBox(height: 2.h),
                ReusableText(
                  text: "Date : ${report.date}",
                  fontSize: 13.sp,
                  letterSpace: 1.5,
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableText(
                  text: "₹ ${report.amount}",
                  fontSize: 17.sp,
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.5,
                )
              ],
            ),
            SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }
}
