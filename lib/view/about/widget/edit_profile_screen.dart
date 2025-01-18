import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: ReusableText(
          text: "Update profile",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpace: 1.3,
        ),
        backgroundColor: appBar,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
