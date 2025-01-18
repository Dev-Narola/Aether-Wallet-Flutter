// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:aether_wallet/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoubleContainer extends StatelessWidget {
  double height;
  double width;
  Widget? child;
  Color? backgroundColor;
  DoubleContainer({
    super.key,
    required this.height,
    required this.width,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: height - 10,
              width: width - 10,
              decoration: BoxDecoration(
                color: border,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: border, width: 2.2),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            right: 6,
            child: Container(
              height: height - 8,
              width: width - 8,
              decoration: BoxDecoration(
                color: backgroundColor ?? lightBackground,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: border, width: 2.0),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
