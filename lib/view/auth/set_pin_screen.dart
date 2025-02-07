// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:aether_wallet/common/loading_screen.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/view/auth/balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  bool isLoading = false;

  late String pin;

  @override
  Widget build(BuildContext context) {
    TextEditingController first = TextEditingController();
    TextEditingController second = TextEditingController();
    TextEditingController third = TextEditingController();
    TextEditingController fourth = TextEditingController();
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: lightBackground,
            appBar: AppBar(
              backgroundColor: appBar,
              centerTitle: true,
              title: ReusableText(
                text: "Set Pin Screen",
                fontSize: 18.sp,
                color: headingText,
                letterSpace: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildPinField(context, first),
                    buildPinField(context, second),
                    buildPinField(context, third),
                    buildPinField(context, fourth, onChanged: (value) {
                      if (value.length == 1) {
                        pin =
                            "${first.text}${second.text}${third.text}${fourth.text}";
                        debugPrint("PIN entered: $pin");
                      }
                    }),
                  ],
                ),
                ReusableButton(
                    text: "Set pin",
                    icon: LineIcons.lock,
                    onTap: () async {
                      if (pin.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please enter pin",
                          colorText: headingText,
                          backgroundColor: error,
                        );
                        return;
                      }
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        isLoading = true;
                      });
                      prefs.setString("pin", pin);
                      String? settedpin = prefs.getString("pin");
                      setState(() {
                        isLoading = false;
                      });
                      if (settedpin!.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Balance(),
                          ),
                        );
                      }
                    })
              ],
            ),
          );
  }

  Widget buildPinField(BuildContext context, TextEditingController controller,
      {Function(String)? onChanged}) {
    return SizedBox(
      height: 64.h,
      width: 68.w,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged ??
            (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
        style: TextStyle(
            color: headingText, letterSpacing: 1.2, fontFamily: 'Kingred'),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        cursorColor: headingText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: subtleText),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: error),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
