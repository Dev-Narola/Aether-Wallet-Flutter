import 'package:aether_wallet/constant/constant.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget? containerContent;
  const CustomContainer({super.key, this.containerContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bottomNavBar,
      height: MediaQuery.of(context).size.height * 0.90,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: lightBackground,
          child: containerContent,
        ),
      ),
    );
  }
}
