// ignore_for_file: depend_on_referenced_packages

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
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        // home: SetPinScreen(),
      ),
    );
  }
}


/*

 Tasks to Complete

1. check internet connection
2. image upload
3. update user/report/category
4. add delete contact api with delete profile 
5. pin checker  -  done
6. analytics page
7. set reminder feature
8. download report feature
9. add animation ( optional )
10. Google Login

*/


// To run 
// 1. check ip
// 2. change current ip in restclient code at base url
// 3. run application