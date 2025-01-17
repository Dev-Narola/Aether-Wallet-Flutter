// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:aether_wallet/common/double_container.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

class CardWidget extends StatefulWidget {
  double? totalBalance;
  double? expanse;
  double? income;
  CardWidget(
      {super.key,
      required this.totalBalance,
      required this.expanse,
      required this.income});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  String getCurrentMonthName() {
    // List of month names
    const List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    // Get the current month index (1-based) and adjust for 0-based list
    int currentMonthIndex = DateTime.now().month - 1;

    // Return the month's name
    return monthNames[currentMonthIndex];
  }

  @override
  Widget build(BuildContext context) {
    return DoubleContainer(
      height: 300,
      width: MediaQuery.of(context).size.width - 28.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableText(
                  text: "Current Balance : \n ₹ ${widget.totalBalance}",
                  fontSize: 20.sp,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: darkBackground, width: 1.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0.w,
                      vertical: 4.0.h,
                    ),
                    child: ReusableText(
                        text: getCurrentMonthName(), fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 38.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ReusableText(
                      text: "Income: \n ₹ ${widget.income}",
                      fontSize: 19.sp,
                      color: lightGreenColor,
                    ),
                    SizedBox(height: 18.h),
                    ReusableText(
                      text: "Expense:\n ₹ ${widget.expanse}",
                      fontSize: 19.sp,
                      color: lightErrorColor,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 48.0),
                  child: SizedBox(
                    width: 100.w,
                    height: 100.h,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            color: lightGreenColor,
                            value: widget.income,
                            title: "Income",
                            showTitle: false,
                            radius: 50,
                          ),
                          PieChartSectionData(
                            color: lightErrorColor,
                            value: widget.expanse,
                            title: "Expense",
                            showTitle: false,
                            radius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
