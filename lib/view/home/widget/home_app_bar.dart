// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/view/about/about_me.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget {
  final Map<String, dynamic> userdata;
  const HomeAppBar({super.key, required this.userdata});

  @override
  Widget build(BuildContext context) {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return "Good morning";
      }
      if (hour < 17) {
        return "Good afternoon";
      }
      return "Good evening";
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(100.h),
      child: Container(
        color: lightAppBarColor,
        child: Padding(
          padding: EdgeInsets.only(top: 14.h, bottom: 6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                          () => AboutMe(
                                userData: userdata,
                              ),
                          transition: Transition.fadeIn);
                    },
                    child: CircleAvatar(
                      backgroundColor: lightTextColor,
                      radius: 25.r,
                      backgroundImage: NetworkImage(userdata['user_image']),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  ReusableText(
                    text: "${greeting()}, ${userdata['name']}",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(LineIcons.barChartAlt)),
            ],
          ),
        ),
      ),
    );
  }
}
