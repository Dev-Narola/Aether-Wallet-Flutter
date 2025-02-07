// ignore_for_file: must_be_immutable, depend_on_referenced_packages, non_constant_identifier_names

import 'package:aether_wallet/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialTextfield extends StatelessWidget {
  IconData? Icondata;
  String text;
  TextEditingController? controller;
  SpecialTextfield({
    super.key,
    this.Icondata,
    required this.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0.h),
      child: TextFormField(
        controller: controller,
        cursorColor: headingText,
        style: TextStyle(
            color: headingText, letterSpacing: 1.2, fontFamily: 'Kingred'),
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
              color: Colors.grey, letterSpacing: 1.2, fontFamily: 'Kingred'),
          prefixIcon: Icon(
            Icondata,
            color: headingText,
          ),
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
