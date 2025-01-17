import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/get_all_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightAppBarColor,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: lightBackground,
                backgroundColor: lightTextColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.7),
                        borderRadius: BorderRadius.circular(100.r)),
                    child: CircleAvatar(
                      radius: 75.r,
                      backgroundColor: lightSecondaryTextColor,
                      backgroundImage: NetworkImage(widget.contact.userImage),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.6, color: lightTextColor),
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                            text: "NAME : ",
                            fontSize: 17.sp,
                            letterSpace: 1.3,
                            fontWeight: FontWeight.bold,
                          ),
                          ReusableText(
                            text: widget.contact.name,
                            fontSize: 17.sp,
                            letterSpace: 1.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.6, color: lightTextColor),
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                            text: "MOBILE NO. : ",
                            fontSize: 17.sp,
                            letterSpace: 1.3,
                            fontWeight: FontWeight.bold,
                          ),
                          ReusableText(
                            text: widget.contact.mobileNo,
                            fontSize: 17.sp,
                            letterSpace: 1.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ReusableButton(
                      text: "Update contact details",
                      icon: LineIcons.userPlus,
                      onTap: () {
                        Get.snackbar("Benchod",
                            "Loda pelethi harkhi details bharvani khabar nathi padti",
                            colorText: darkTextColor,
                            backgroundColor: lightTextColor);
                      }),
                  SizedBox(height: 20.h),
                  ReusableButton(
                      text: "Delete Contact",
                      icon: LineIcons.trash,
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString('token');
                        String finalToken = "Bearer $token";

                        restClient
                            .deleteContact(finalToken, widget.contact.id)
                            .then((response) {
                          setState(() {
                            isLoading = false;
                          });

                          Get.snackbar(
                            "Success",
                            response.message,
                            backgroundColor: lightButtonColor,
                            colorText: darkTextColor,
                          );

                          Get.to(() => BottomNavigationBarr());
                        });
                      })
                ],
              ),
            ),
    );
  }
}
