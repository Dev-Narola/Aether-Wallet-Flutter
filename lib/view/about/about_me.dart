// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:aether_wallet/common/double_container.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/view/about/widget/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class AboutMe extends StatelessWidget {
  final Map<String, dynamic> userData;
  const AboutMe({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: headingText,
          ),
        ),
        backgroundColor: appBar,
        centerTitle: true,
        title: typeWriterAnimatedText(
          text: "About Me",
          color: headingText,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
          letterSpace: 1.5,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: headingText,
                  borderRadius: BorderRadius.circular(120.r),
                  border: Border.all(color: headingText, width: 1.5.w),
                ),
                child: CircleAvatar(
                  radius: 110.r,
                  backgroundColor: lightBackground,
                  backgroundImage: NetworkImage(
                    userData['user_image'],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            typeWriterAnimatedText(
              text: userData['name'],
              color: headingText,
              fontSize: 20.sp,
              letterSpace: 1.4,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10.h),
            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              decoration: BoxDecoration(
                border: Border.all(color: divider, width: 1.1.w),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),
            aboutMeDataWidget(
              prefixName: "Email : ",
              suffixName: userData['email'],
            ),
            SizedBox(height: 10.h),
            aboutMeDataWidget(
              prefixName: "Phone : ",
              suffixName: userData['mobile_no'],
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () {
                Get.to(() => EditProfileScreen(),
                    transition: Transition.fadeIn);
              },
              child: DoubleContainer(
                height: 50.h,
                width: MediaQuery.of(context).size.width * 0.92,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ReusableText(
                      text: "Edit Profile",
                      color: headingText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      wordSpace: 1.2,
                    ),
                    SizedBox(width: 10.w),
                    Icon(LineIcons.editAlt, color: headingText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class aboutMeDataWidget extends StatelessWidget {
  String prefixName;
  String suffixName;
  aboutMeDataWidget({
    super.key,
    required this.prefixName,
    required this.suffixName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(
          text: prefixName,
          color: headingText,
          fontSize: 17.sp,
          letterSpace: 1.4,
        ),
        ReusableText(
          text: suffixName,
          color: headingText,
          fontSize: 17.sp,
          letterSpace: 1.4,
        ),
      ],
    );
  }
}
