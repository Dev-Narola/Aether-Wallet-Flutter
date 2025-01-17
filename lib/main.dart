// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        title: 'Aether Wallet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: lightTextColor),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
