import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/add_contect_request.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  // TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mobileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightAppBarColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            LineIcons.arrowLeft,
          ),
        ),
        title: ReusableText(
          text: "Add Contact",
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          letterSpace: 1.3,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(text: "Please fill all the details"),
              SizedBox(height: 10.h),
              ReusableText(
                text: "Name",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                letterSpace: 1.3,
              ),
              SpecialTextfield(
                text: "Name",
                Icondata: LineIcons.user,
                controller: nameController,
              ),
              SizedBox(height: 10.h),
              ReusableText(
                text: "Mobile number",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                letterSpace: 1.3,
              ),
              SpecialTextfield(
                text: "Mobile number",
                Icondata: LineIcons.phone,
                controller: mobileController,
              ),
              SizedBox(height: 10.h),
              ReusableText(
                text: "User image",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                letterSpace: 1.3,
              ),
              SizedBox(height: 6.h),
              DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12.r),
                color: lightTextColor,
                strokeWidth: 1,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableText(
                        text: "User image",
                        fontSize: 15.sp,
                        color: lightTextColor,
                      ),
                      SizedBox(width: 10.w),
                      Icon(LineIcons.plusCircle, color: lightTextColor),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.8), color: lightTextColor),
              ),
              SizedBox(height: 16.h),
              ReusableButton(
                  text: "Add Contact",
                  icon: LineIcons.plusCircle,
                  onTap: () async {
                    if (nameController.text.isEmpty ||
                        mobileController.text.isEmpty) {
                      Get.snackbar("Error", "Please fill all the details",
                          colorText: darkTextColor,
                          backgroundColor: lightErrorColor);
                      return;
                    }

                    if (mobileController.text.length > 10 ||
                        mobileController.text.isAlphabetOnly) {
                      Get.snackbar(
                          "Error", "Please enter mobile number properly",
                          colorText: darkTextColor,
                          backgroundColor: lightErrorColor);
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? token = prefs.getString("token");
                    String finalToken = "Bearer $token";

                    AddContectRequest addContact = AddContectRequest(
                      name: nameController.text,
                      mobileNo: mobileController.text,
                      userImage:
                          "https://img.freepik.com/premium-vector/cool-guy-t-shirt-template-line-art-illustration_518698-351.jpg",
                    );

                    restClient
                        .addContect(finalToken, addContact)
                        .then((response) {
                      Get.snackbar("Success", "Successfully added contect",
                          colorText: darkTextColor,
                          backgroundColor: lightGreenColor);
                      Get.off(() => BottomNavigationBarr());
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
