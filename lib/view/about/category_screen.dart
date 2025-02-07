// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/loading_screen.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/categories_response.dart';
import 'package:aether_wallet/models/category_request.dart';
import 'package:aether_wallet/view/about/widget/category_tile.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isLoading = false;
  CategoriesResponse? categoriesResponse;

  Future<void> getCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token != null) {
        String finalToken = "Bearer $token";
        final categories = await restClient.getCategories(finalToken);

        setState(() {
          categoriesResponse = CategoriesResponse(
            categories: categories.categories,
          );
          isLoading = false;
        });
      } else {
        debugPrint("Token not found");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
        letterSpace: 1.3,
      ),
    ),
    DropdownMenuItem(
      value: "Expense",
      child: ReusableText(
        text: "Expense",
        fontSize: 16.sp,
        color: headingText,
        letterSpace: 1.3,
      ),
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: headingText,
            )),
        centerTitle: true,
        title: ReusableText(
          text: "Manage category",
          fontSize: 20.sp,
          color: headingText,
          fontWeight: FontWeight.bold,
          letterSpace: 1.5,
        ),
        backgroundColor: appBar,
        actions: [
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                    child: ReusableText(
                      text: "Add Category",
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
                            ReusableText(text: "Title", fontSize: 16.sp),
                            SizedBox(height: 5.h),
                            SpecialTextfield(
                              text: "Title",
                              Icondata: LineIcons.sellcast,
                              controller: _titleController,
                            ),
                            SizedBox(height: 10.h),
                            ReusableText(text: "Type", fontSize: 16.sp),
                            SizedBox(height: 5.h),
                            DropdownButtonFormField(
                              value: null,
                              onChanged: (value) {
                                setDialogState(() {
                                  _typeController.text = value.toString();
                                });
                              },
                              items: _type,
                              icon: Icon(LineIcons.angleDown, size: 22.sp),
                              dropdownColor: lightBackground,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: headingText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            ReusableText(text: "Image", fontSize: 16.sp),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                        fontSize: 16.sp,
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

                        var request = CategoryRequest(
                          _titleController.text,
                          _typeController.text,
                          "https://img.freepik.com/premium-photo/contact-icon-3d-render-illustration_567294-3221.jpg",
                          _selectedColor.toString(),
                        );

                        restClient
                            .addcategory(finalToken, request)
                            .then((response) {
                          setState(() {
                            isLoading = false;
                          });
                          Get.snackbar(
                            "Success",
                            response.message,
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: success,
                            colorText: subtleText,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigationBarr(),
                            ),
                          );
                        }).catchError((error) {
                          setState(() {
                            isLoading = false;
                          });
                          String errorMessage =
                              "Something went wrong. Please try again.";
                          if (error is DioException &&
                              error.response?.data != null) {
                            errorMessage =
                                error.response?.data['message'] ?? errorMessage;
                          }
                          debugPrint('Error: $errorMessage');
                          Get.snackbar(
                            "Error",
                            errorMessage,
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: error,
                            colorText: subtleText,
                          );
                        });
                      },
                      child: ReusableText(
                        text: "Save",
                        fontSize: 16.sp,
                        color: headingText,
                      ),
                    ),
                  ],
                );
              },
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 18.0.w),
              child:
                  Icon(LineIcons.plusCircle, size: 30.sp, color: headingText),
            ),
          ),
        ],
      ),
      body: isLoading
          ? LoadingScreen()
          : RefreshIndicator(
              onRefresh: getCategories,
              child: categoriesResponse != null &&
                      categoriesResponse!.categories.isNotEmpty
                  ? ListView.builder(
                      itemCount: categoriesResponse!.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoriesResponse!.categories[index];
                        return category_tile(category: category);
                      },
                    )
                  : Center(
                      child: Text(
                        "No Categories Available",
                        style: TextStyle(fontSize: 16, color: subtleText),
                      ),
                    ),
            ),
    );
  }
}
