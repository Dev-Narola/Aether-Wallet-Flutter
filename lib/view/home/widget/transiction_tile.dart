// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/common/double_container.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransictionTile extends StatelessWidget {
  final Report report;
  const TransictionTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    Color amountColor =
        report.reportType == "Expense" ? Colors.red : lightGreenColor;
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
                Text(
                  report.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  report.categories.name,
                  style: TextStyle(fontSize: 13.sp, color: lightTextColor),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Date : ${report.date}",
                  style: TextStyle(fontSize: 13.sp, color: lightTextColor),
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₹ ${report.amount}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }
}
