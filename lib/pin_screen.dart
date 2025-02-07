// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController first = TextEditingController();
  final TextEditingController second = TextEditingController();
  final TextEditingController third = TextEditingController();
  final TextEditingController fourth = TextEditingController();

  Future<bool> checkPin(String enteredPin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? setPin = prefs.getString('pin');
    return enteredPin == setPin;
  }

  Future<void> handlePinValidation() async {
    String pin = "${first.text}${second.text}${third.text}${fourth.text}";

    if (pin.length < 4) {
      Get.snackbar(
        "Error",
        "Please enter a 4-digit PIN",
        colorText: headingText,
        backgroundColor: error,
      );
      return;
    }

    bool isValid = await checkPin(pin);
    if (!isValid) {
      Get.snackbar(
        "Error",
        "Incorrect PIN. Try again.",
        colorText: headingText,
        backgroundColor: error,
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      Get.snackbar(
        "Error",
        "User token not found. Please log in again.",
        colorText: headingText,
        backgroundColor: error,
      );
      return;
    }

    // Navigate only after ensuring data is available
    Get.offAll(() => BottomNavigationBarr());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildPinField(context, first, isLastField: false),
              buildPinField(context, second, isLastField: false),
              buildPinField(context, third, isLastField: false),
              buildPinField(context, fourth, isLastField: true),
            ],
          ),
          ReusableButton(
            text: "Continue",
            icon: LineIcons.arrowCircleRight,
            onTap: handlePinValidation,
          ),
        ],
      ),
    );
  }

  Widget buildPinField(BuildContext context, TextEditingController controller,
      {bool isLastField = false}) {
    return SizedBox(
      height: 64.h,
      width: 68.w,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1 && !isLastField) {
            FocusScope.of(context).nextFocus();
          } else if (value.length == 1 && isLastField) {
            FocusScope.of(context).unfocus();
          }
        },
        style: const TextStyle(
          color: headingText,
          letterSpacing: 1.2,
        ),
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
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: headingText),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
