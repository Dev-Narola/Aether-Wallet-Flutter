// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/signin_request.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:aether_wallet/view/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: isLoading
          ? Center(
              child: const CircularProgressIndicator(
                backgroundColor: darkAppBarColor,
                color: darkTextColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Center(
                      child: Image.network(
                        "https://res.cloudinary.com/ddl7jfvpu/image/upload/v1735957942/confirmed-concept-illustration_114360-545-removebg-preview_elhkz8.png",
                        height: 280.h,
                        width: 280.w,
                      ),
                    ),
                    ReusableText(
                      text: "Sign in to get Started",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    ReusableText(
                      text: "Sign in with same creadentials",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(height: 10.h),
                    SpecialTextfield(
                      text: "email",
                      Icondata: LineIcons.userCircleAlt,
                      controller: emailController,
                    ),
                    SizedBox(height: 10.h),
                    SpecialTextfield(
                      text: "password",
                      Icondata: LineIcons.userCircleAlt,
                      controller: passwordController,
                    ),
                    Row(
                      children: [
                        ReusableText(
                          text: "Create new account ?",
                          fontSize: 14.sp,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(() => SignupScreen());
                            },
                            child: ReusableText(
                              text: "Signup",
                              fontSize: 14.sp,
                              color: Colors.lightBlueAccent,
                            ))
                      ],
                    ),
                    ReusableButton(
                      text: "Let's get Started",
                      icon: LineIcons.arrowCircleRight,
                      onTap: () async {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please fill all the fields",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: lightErrorColor,
                            colorText: darkTextColor,
                          );
                          return;
                        }

                        if (!emailController.text.contains("@")) {
                          Get.snackbar(
                            "Error",
                            "Invalid email address",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: lightErrorColor,
                            colorText: darkTextColor,
                          );
                          return;
                        }

                        if (passwordController.text.length < 6) {
                          Get.snackbar(
                            "Error",
                            "Password must be at least 6 characters",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: lightErrorColor,
                            colorText: darkTextColor,
                          );
                          return;
                        }

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString("token");
                        String finalToken = "bearer $token";

                        setState(() {
                          isLoading = true;
                        });

                        final signinRequest = SigninRequest(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        restClient.signin(finalToken, signinRequest).then((
                          response,
                        ) async {
                          Get.snackbar(
                            "Success",
                            response.message,
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: lightGreenColor,
                            colorText: darkTextColor,
                          );

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("token", response.token);
                          prefs.setBool("isLogin", true);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BottomNavigationBarr(),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
