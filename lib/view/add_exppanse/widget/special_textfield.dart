// ignore_for_file: must_be_immutable

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
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(color: Colors.grey),

          prefixIcon: Icon(Icondata),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: lightTextColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: lightErrorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: lightErrorColor),
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
