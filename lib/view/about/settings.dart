// ignore_for_file: must_be_immutable, camel_case_types, depend_on_referenced_packages

import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/double_container.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/splash_screen.dart';
import 'package:aether_wallet/view/about/about_me.dart';
import 'package:aether_wallet/view/about/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class About extends StatefulWidget {
  final Map<String, dynamic> userData;
  const About({super.key, required this.userData});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: lightAppBarColor,
        centerTitle: true,
        title: ReusableText(
          text: "Settings",
          color: lightTextColor,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            settingPageOptions(
              onTap: () {
                Get.to(
                    () => AboutMe(
                          userData: widget.userData,
                        ),
                    transition: Transition.fadeIn);
              },
              text: "About me",
            ),
            settingPageOptions(text: "Set Reminder"),
            settingPageOptions(
              text: "Manage category",
              onTap: () {
                Get.to(() => CategoryScreen(), transition: Transition.fadeIn);
              },
            ),
            settingPageOptions(text: "Expanse Report"),
            settingPageOptions(
              text: "Logout",
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString("token");
                String finalToken = "bearer $token";

                setState(() {
                  isLoading = true;
                });
                restClient.logout(finalToken).then((response) {
                  Get.snackbar(
                    "Success",
                    response.message,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: lightGreenColor,
                    colorText: darkTextColor,
                  );
                  prefs.remove("token");
                  prefs.setBool("isLogin", false);

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                  );
                });
              },
            ),
            settingPageOptions(
              text: "Delete account",
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString("token");
                String finalToken = "bearer $token";

                setState(() {
                  isLoading = true;
                });
                restClient.deleteAccount(finalToken).then((response) {
                  Get.snackbar(
                    "Success",
                    response.message,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: lightGreenColor,
                    colorText: darkTextColor,
                  );
                  prefs.remove("token");
                  prefs.setBool("isLogin", false);
                  prefs.setBool("isSignup", false);

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class settingPageOptions extends StatelessWidget {
  String text;
  void Function()? onTap;
  settingPageOptions({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: DoubleContainer(
          height: 50.h,
          width: MediaQuery.of(context).size.width * 0.92,
          child: Center(
            child: ReusableText(
              text: text,
              color: lightTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              wordSpace: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
