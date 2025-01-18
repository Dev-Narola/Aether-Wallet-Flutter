// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/get_all_contacts.dart';
import 'package:aether_wallet/view/contact/add_contact.dart';
import 'package:aether_wallet/view/contact/widget/user_contect_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool isLoading = false;
  List<Contact> contactList = [];

  Future<void> fetchContacts() async {
    try {
      setState(() {
        isLoading = true; // Show loading while refreshing
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      if (token != null) {
        String finalToken = "Bearer $token";
        restClient.getAllContacts(finalToken).then((response) {
          setState(() {
            contactList = response.contacts;
            isLoading = false; // Stop loading
          });
        });
      } else {
        debugPrint("Token not found");
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      debugPrint("Error fetching contacts: $e");
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBar,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: ReusableText(
          text: "Contact Screen",
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          letterSpace: 1.5,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchContacts,
        child: contactList.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                child: ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => UserContectScreen(contact: contact));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0.h),
                        child: Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: lightBackground,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              width: 1.5,
                              color: headingText,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 28.r,
                                  backgroundColor: subtleText,
                                  backgroundImage:
                                      NetworkImage(contact.userImage),
                                ),
                                SizedBox(width: 16.w),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableText(
                                      text: contact.name,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpace: 1.3,
                                    ),
                                    ReusableText(
                                      text: contact.mobileNo,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal,
                                      letterSpace: 1.3,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                ReusableText(
                                  text: contact.amount.toString(),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpace: 1.5,
                                  color: contact.amount >= 0 ? success : error,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: ReusableText(
                  text: "No contacts found",
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  letterSpace: 1.3,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddContact());
        },
        backgroundColor: primaryButton,
        shape: CircleBorder(),
        child: Icon(
          LineIcons.userPlus,
          color: lightBackground,
          size: 26.sp,
        ),
      ),
    );
  }
}
