// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/custom_container.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:aether_wallet/view/home/report_screen.dart';
import 'package:aether_wallet/view/home/view_all_report_screen.dart';
import 'package:aether_wallet/view/home/widget/card_widget.dart';
import 'package:aether_wallet/view/home/widget/home_app_bar.dart';
import 'package:aether_wallet/view/home/widget/transiction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final double? userBalance;
  final double? expanse;
  final double? income;
  final List<Report> reports;

  const HomeScreen({
    super.key,
    required this.userData,
    this.userBalance,
    required this.reports,
    this.expanse,
    this.income,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: CustomContainer(
          containerContent: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBar(userdata: widget.userData),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      CardWidget(
                        totalBalance: widget.userBalance,
                        expanse: widget.expanse,
                        income: widget.income,
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          ReusableText(
                            text: "Recent Transactions",
                            fontSize: 19.sp,
                            fontWeight: FontWeight.bold,
                            letterSpace: 1.5,
                            color: headingText,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  ViewAllReportScreen(reports: widget.reports));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 8.0.w),
                              child: ReusableText(
                                text: "View All",
                                letterSpace: 1.3,
                                fontSize: 16.sp,
                                color: normalText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      widget.reports.isEmpty
                          ? Center(
                              child: ReusableText(
                                text: "No report available",
                                fontSize: 20.sp,
                                color: headingText,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.reports.length > 5
                                  ? 5
                                  : widget.reports.length,
                              itemBuilder: (context, index) {
                                final Report report = widget.reports[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.0.h),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ReportScreen(report: report),
                                        transition: Transition.fadeIn,
                                      );
                                    },
                                    child: TransictionTile(report: report),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
