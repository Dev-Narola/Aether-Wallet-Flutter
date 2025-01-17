// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/signup_request.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:aether_wallet/view/auth/balance.dart';
import 'package:aether_wallet/view/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                padding: EdgeInsets.symmetric(horizontal: 14.0.w),
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
                      text: "Create an account",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    ReusableText(
                      text: "Sign up to get started",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(height: 15.h),
                    SpecialTextfield(
                      text: "Name",
                      Icondata: LineIcons.userCircleAlt,
                      controller: nameController,
                    ),
                    SizedBox(height: 10.h),
                    SpecialTextfield(
                      text: "Email",
                      Icondata: LineIcons.envelope,
                      controller: emailController,
                    ),
                    SizedBox(height: 10.h),
                    SpecialTextfield(
                      text: "Mobile No",
                      Icondata: LineIcons.phone,
                      controller: mobileController,
                    ),
                    SizedBox(height: 10.h),
                    SpecialTextfield(
                      text: "Password",
                      Icondata: LineIcons.lock,
                      controller: passwordController,
                    ),
                    Row(
                      children: [
                        ReusableText(
                          text: "Do you already have account ?",
                          fontSize: 14.sp,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(() => LoginScreen());
                            },
                            child: ReusableText(
                              text: "Signin",
                              fontSize: 14.sp,
                              color: Colors.lightBlueAccent,
                            ))
                      ],
                    ),
                    ReusableButton(
                      text: "Add balance",
                      icon: LineIcons.arrowCircleRight,
                      onTap: () {
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            mobileController.text.isEmpty ||
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

                        if (mobileController.text.length < 10) {
                          Get.snackbar(
                            "Error",
                            "Mobile number must be at least 10 characters",
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

                        setState(() {
                          isLoading = true;
                        });
                        final signupRequest = SignupRequest(
                          name: nameController.text,
                          email: emailController.text,
                          mobile_no: mobileController.text,
                          password: passwordController.text,
                          user_image:
                              "https://img.freepik.com/premium-photo/memoji-handsome-guy-man-with-glasses-white-background-emoji-cartoon-character_826801-6961.jpg",
                        );
                        restClient.signup(signupRequest).then((response) async {
                          setState(() {
                            isLoading = false;
                          });
                          debugPrint('Token: ${response.token}');
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
                          await prefs.setBool("isSignup", true);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Balance(),
                            ),
                          );
                        }).catchError((error) {
                          setState(() {
                            isLoading = false;
                          });
                          String errorMessage =
                              "Something went wrong. Please try again.";
                          if (error is DioError) {
                            // Check if the error has a response with a message
                            if (error.response?.data != null &&
                                error.response?.data is Map) {
                              errorMessage = error.response?.data['message'] ??
                                  errorMessage;
                            }
                          }

                          debugPrint('Error: $errorMessage');
                          Get.snackbar(
                            "Error",
                            errorMessage,
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: lightErrorColor,
                            colorText: darkTextColor,
                          );
                        });
                      },
                    ),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            ),
    );
  }
}
