// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

// import 'dart:math';

import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/categories_response.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class category_tile extends StatefulWidget {
  const category_tile({super.key, required this.category});

  final Category category;

  @override
  State<category_tile> createState() => _category_tileState();
}

class _category_tileState extends State<category_tile> {
  bool isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final List<Color> _availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];
  Color _selectedColor = Colors.red;

  final List<DropdownMenuItem> _type = [
    DropdownMenuItem(
      value: "Income",
      child: ReusableText(
        text: "Income",
        fontSize: 16.sp,
        color: headingText,
      ),
    ),
    DropdownMenuItem(
      value: "Expense",
      child: ReusableText(
        text: "Expense",
        fontSize: 16.sp,
        color: headingText,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: headingText, width: 1.5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 15.w),
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage: NetworkImage(widget.category.icon),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  SizedBox(width: 20.w),
                  ReusableText(
                    text: widget.category.name,
                    color: headingText,
                    fontSize: 17.sp,
                    letterSpace: 1.3,
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(
                            child: ReusableText(
                              text: "Update Category",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: appBar,
                          content: StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setDialogState,
                            ) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8.h),
                                    ReusableText(
                                      text: "Title",
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(height: 5.h),
                                    SpecialTextfield(
                                      text: "Title",
                                      Icondata: LineIcons.sellcast,
                                      controller: _titleController,
                                    ),
                                    SizedBox(height: 10.h),
                                    ReusableText(
                                      text: "Type",
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(height: 5.h),
                                    DropdownButtonFormField(
                                      value: null,
                                      onChanged: (value) {
                                        setDialogState(() {
                                          _typeController.text =
                                              value.toString();
                                        });
                                      },
                                      items: _type,
                                      icon: Icon(
                                        LineIcons.angleDown,
                                        size: 22.sp,
                                      ),
                                      dropdownColor: lightBackground,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                            color: headingText,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    ReusableText(
                                      text: "Image",
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(height: 8.h),
                                    DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(12.r),
                                      color: headingText,
                                      strokeWidth: 1,
                                      child: SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ReusableText(
                                              text: "Attach Bill",
                                              fontSize: 15.sp,
                                              color: headingText,
                                            ),
                                            SizedBox(width: 10.w),
                                            Icon(
                                              LineIcons.plusCircle,
                                              color: headingText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    ReusableText(
                                      text: "Select Color",
                                      fontSize: 16.sp,
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _availableColors.map((color) {
                                        return GestureDetector(
                                          onTap: () {
                                            setDialogState(() {
                                              _selectedColor = color;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 4.0.w,
                                            ),
                                            width: 30.w,
                                            height: 30.w,
                                            decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: _selectedColor == color
                                                    ? darkBackground
                                                    : Colors.transparent,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: ReusableText(
                                text: "Cancel",
                                color: error,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: ReusableText(
                                text: "Update",
                                color: primaryButton,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    child: Icon(
                      LineIcons.pen,
                      color: headingText,
                      size: 26.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: lightBackground,
                          title: ReusableText(
                            text: "Are you sure to delete Category ?",
                            fontSize: 16.sp,
                            color: headingText,
                            fontWeight: FontWeight.bold,
                            letterSpace: 1.3,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: ReusableText(
                                text: "Cancel",
                                color: headingText,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String? token = prefs.getString("token");
                                String finalToken = "Bearer $token";

                                setState(() {
                                  isLoading = true;
                                });
                                restClient.deleteCategory(finalToken, {
                                  "category_id": widget.category.id,
                                }).then((response) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Get.snackbar(
                                    "Success",
                                    response.message,
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: success,
                                    colorText: headingText,
                                  );
                                  Navigator.pop(context);
                                }).catchError((error) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  String errorMessage =
                                      "Something went wrong. Please try again.";
                                  if (error is DioException &&
                                      error.response?.data != null) {
                                    errorMessage =
                                        error.response?.data['message'] ??
                                            errorMessage;
                                  }
                                  debugPrint('Error: $errorMessage');
                                  Get.snackbar(
                                    "Error",
                                    errorMessage,
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: error,
                                    colorText: headingText,
                                  );
                                });
                              },
                              child: ReusableText(
                                text: "Delete",
                                color: error,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    child: Icon(
                      LineIcons.trash,
                      color: error,
                      size: 26.sp,
                    ),
                  ),
                  SizedBox(width: 20.w),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
