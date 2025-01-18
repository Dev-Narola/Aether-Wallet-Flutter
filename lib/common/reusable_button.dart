// ignore_for_file: must_be_immutable

import 'package:aether_wallet/common/double_container.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableButton extends StatelessWidget {
  String text;
  IconData icon;
  void Function() onTap;
  ReusableButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DoubleContainer(
        height: 48.h,
        width: MediaQuery.of(context).size.width * 0.92,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReusableText(
              text: text,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              letterSpace: 1.4,
            ),
            SizedBox(width: 10.w),
            Icon(icon, size: 22.sp, color: normalText),
          ],
        ),
      ),
    );
  }
}
