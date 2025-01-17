// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/balance_model.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:aether_wallet/view/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Balance extends StatefulWidget {
  const Balance({super.key});

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  TextEditingController balanceController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightAppBarColor,
        automaticallyImplyLeading: false,
      ),
      body:
          isLoading
              ? Center(
                child: const CircularProgressIndicator(
                  backgroundColor: darkAppBarColor,
                  color: darkTextColor,
                ),
              )
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: "Enter your balance",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    ReusableText(
                      text: "Enter your balance to get started",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(height: 15.h),
                    SpecialTextfield(
                      text: "Balance",
                      Icondata: LineIcons.wavyMoneyBill,
                      controller: balanceController,
                    ),
                    SizedBox(height: 25.h),
                    ReusableButton(
                      text: "Sign up",
                      icon: LineIcons.arrowCircleRight,
                      onTap: () async {
                        if (balanceController.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter balance",
                            backgroundColor: lightErrorColor,
                            colorText: darkTextColor,
                            snackPosition: SnackPosition.TOP,
                          );
                        }

                        double balance = double.parse(balanceController.text);

                        if (balance < 0) {
                          Get.snackbar(
                            "Error",
                            "Balance must be more than 0",
                            backgroundColor: lightErrorColor,
                            colorText: darkTextColor,
                            snackPosition: SnackPosition.TOP,
                          );
                        }

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString("token");
                        String finalToken = "bearer ${token}";
                        print(finalToken);

                        setState(() {
                          isLoading = true;
                        });

                        final balanceModel = BalanceModel(balance: balance);

                        restClient.addbalance(finalToken, balanceModel).then((
                          response,
                        ) {
                          setState(() {
                            isLoading = false;
                          });

                          Get.snackbar(
                            "Success",
                            response.message,
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: lightGreenColor,
                            colorText: darkTextColor,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
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
