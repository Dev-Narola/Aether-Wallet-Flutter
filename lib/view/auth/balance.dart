// ignore_for_file: depend_on_referenced_packages, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/loading_screen.dart';
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
        backgroundColor: appBar,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? LoadingScreen()
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
                          backgroundColor: error,
                          colorText: headingText,
                          snackPosition: SnackPosition.TOP,
                        );
                      }

                      double balance = double.parse(balanceController.text);

                      if (balance < 0) {
                        Get.snackbar(
                          "Error",
                          "Balance must be more than 0",
                          backgroundColor: error,
                          colorText: headingText,
                          snackPosition: SnackPosition.TOP,
                        );
                      }

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? token = prefs.getString("token");
                      String finalToken = "bearer ${token}";
                      debugPrint(finalToken);

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
                          backgroundColor: success,
                          colorText: headingText,
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
