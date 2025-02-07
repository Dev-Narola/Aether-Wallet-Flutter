// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously, prefer_typing_uninitialized_variables, unused_field

import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/controller/balance_controller.dart';
import 'package:aether_wallet/controller/image_controller.dart';
import 'package:aether_wallet/models/add_report_request.dart';
import 'package:aether_wallet/models/categories_response.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class AddExpanse extends StatefulWidget {
  final categoryList;
  final currentBalance;
  const AddExpanse(
      {super.key, required this.categoryList, this.currentBalance});

  @override
  _AddExpanseState createState() => _AddExpanseState();
}

class _AddExpanseState extends State<AddExpanse> {
  final ImageController _imageController = Get.put(ImageController());

  bool isLoading = false;
  bool imageUploading = false;
  late List<Category> categories;
  late List<Category> filteredCategories; // Add filtered categories list
  late BalanceController balanceController;

  @override
  void initState() {
    super.initState();
    categories = widget.categoryList;
    filteredCategories = categories; // Initially show all categories
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _titleController.dispose();
    _merchantNameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _typeController.dispose();
    _billImageController.dispose();
  }

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _merchantNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _billImageController = TextEditingController();

  bool switchValue = false;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryButton,
              onPrimary: lightBackground,
              onSurface: lightBackground,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryButton),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  final List<DropdownMenuItem> _type = [
    DropdownMenuItem(
      value: "Income",
      child: ReusableText(
        text: "Incom",
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

  void _onTypeChanged(String? value) {
    setState(() {
      _typeController.text = value!;
      // Filter categories based on selected type
      if (_typeController.text == "Expense") {
        filteredCategories =
            categories.where((category) => category.type == "Expense").toList();
      } else {
        filteredCategories =
            categories.where((category) => category.type == "Income").toList();
      }
    });
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
              Icons.arrow_back_ios_new,
              color: headingText,
            )),
        centerTitle: true,
        backgroundColor: appBar,
        automaticallyImplyLeading: true,
        title: ReusableText(
          text: "Add Expanse",
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: headingText,
          letterSpace: 1.5,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              ReusableText(
                text: "Title",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: headingText,
                letterSpace: 1.5,
              ),
              SpecialTextfield(
                Icondata: LineIcons.font,
                text: "Title",
                controller: _titleController,
              ),
              ReusableText(
                text: "Merchant Name",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: headingText,
                letterSpace: 1.5,
              ),
              SpecialTextfield(
                Icondata: LineIcons.userAstronaut,
                text: "Merchant name",
                controller: _merchantNameController,
              ),
              ReusableText(
                text: "Description",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: headingText,
                letterSpace: 1.5,
              ),
              SpecialTextfield(
                text: "Description",
                Icondata: LineIcons.fileAlt,
                controller: _descriptionController,
              ),
              ReusableText(
                text: "Date",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: headingText,
                letterSpace: 1.5,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: SpecialTextfield(
                    text: "Date",
                    Icondata: LineIcons.calendar,
                    controller: _dateController,
                  ),
                ),
              ),
              ReusableText(
                text: "Type",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: headingText,
                letterSpace: 1.5,
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField(
                onSaved: (newValue) {
                  _typeController.text = newValue.toString();
                },
                icon: Icon(
                  LineIcons.angleDown,
                  size: 22.sp,
                  color: headingText,
                ),
                hint: Row(
                  children: [
                    Icon(
                      LineIcons.alignCenter,
                      color: headingText,
                    ),
                    SizedBox(width: 10.w),
                    ReusableText(
                      text: "Type",
                      fontSize: 16.sp,
                      color: headingText,
                    ),
                  ],
                ),
                dropdownColor: lightBackground,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: headingText),
                  ),
                ),
                items: _type,
                onChanged: (value) {
                  setState(() {
                    _onTypeChanged(value);
                    _typeController.text = value;
                  });
                },
              ),
              SizedBox(height: 8.h),
              ReusableText(
                text: "Category",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: headingText,
                letterSpace: 1.5,
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField(
                // onSaved: (newValue) {
                //   _categoryController.text = newValue.toString();
                // },
                icon: Icon(
                  LineIcons.angleDown,
                  size: 22.sp,
                  color: headingText,
                ),
                hint: Row(
                  children: [
                    Icon(
                      LineIcons.alignCenter,
                      color: headingText,
                    ),
                    SizedBox(width: 10.w),
                    ReusableText(
                      text: "Category",
                      fontSize: 16.sp,
                      color: headingText,
                    ),
                  ],
                ),
                dropdownColor: subtleText,

                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: headingText),
                  ),
                ),
                items: filteredCategories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: ReusableText(text: category.name),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    _categoryController.text = value!;
                  });
                },
                onSaved: (newValue) {
                  debugPrint("======================> $newValue");
                },
              ),
              SizedBox(height: 8.h),
              ReusableText(
                text: "Amount",
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: headingText,
                letterSpace: 1.5,
              ),
              SpecialTextfield(
                Icondata: LineIcons.wavyMoneyBill,
                text: "Amount",
                controller: _amountController,
              ),
              Row(
                children: [
                  ReusableText(
                    text: "Attach Bill",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: headingText,
                    letterSpace: 1.5,
                  ),
                  SizedBox(width: 10.w),
                  Switch(
                    value: switchValue,
                    activeColor: inputBackground,
                    activeTrackColor: headingText,
                    inactiveThumbColor: placeholder,
                    inactiveTrackColor: lightBackground,
                    onChanged: (bool value) {
                      setState(() {
                        switchValue = value;
                      });
                    },
                  ),
                ],
              ),
              if (switchValue)
                GetBuilder<ImageController>(
                  builder: (controller) {
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          imageUploading = true;
                        });

                        try {
                          // Select Image from Gallery
                          await controller.selectImage(ImageSource.gallery);

                          if (controller.selectedImage != null) {
                            // Upload to Cloudinary
                            await controller.uploadImageToCloudinary();
                          }

                          // Ensure Image URL is Set
                          String? uploadedImageUrl = controller.imageUrl;

                          _billImageController.text = uploadedImageUrl!;

                          debugPrint(
                              "Final Image URL in _billImageController: ${_billImageController.text}");

                          Get.snackbar(
                            "Success",
                            "Image uploaded successfully",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        } catch (error) {
                          debugPrint(
                              "Error during image upload: ${error.toString()}");
                          Get.snackbar(
                            "Error",
                            error.toString(),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } finally {
                          setState(() {
                            imageUploading = false;
                          });
                        }
                      },
                      child: imageUploading
                          ? Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: lightBackground,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: headingText,
                                ),
                              ),
                            )
                          : _billImageController.text.isEmpty
                              ? DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12.r),
                                  color: headingText,
                                  strokeWidth: 1,
                                  child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(LineIcons.plusCircle,
                                              color: headingText, size: 30),
                                          SizedBox(height: 10.h),
                                          ReusableText(
                                            text: "Attach Bill",
                                            fontSize: 20.sp,
                                            color: headingText,
                                            letterSpace: 1.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.network(
                                    _billImageController.text,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    );
                  },
                ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Get.to(() => BottomNavigationBarr());
                },
                child: ReusableButton(
                  text: "Add Expanse",
                  icon: LineIcons.arrowCircleRight,
                  onTap: () async {
                    // print("title : ${_titleController.text}");
                    // print("merchant name : ${_merchantNameController.text}");
                    // print("description : ${_descriptionController.text}");
                    // print("date : ${_dateController.text}");
                    // print("type : ${_typeController.text}");
                    // print("category : ${_categoryController.text}");
                    // print("amount : ${_amountController.text}");
                    if (_titleController.text.isEmpty ||
                        _merchantNameController.text.isEmpty ||
                        _descriptionController.text.isEmpty ||
                        _dateController.text.isEmpty ||
                        _typeController.text.isEmpty ||
                        _categoryController.text.isEmpty ||
                        _amountController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please fill all the details",
                        colorText: headingText,
                        backgroundColor: error,
                      );
                      return;
                    }

                    if (_amountController.text.isAlphabetOnly) {
                      Get.snackbar(
                        "Error",
                        "Amount value must be in number form",
                        colorText: headingText,
                        backgroundColor: error,
                      );
                      return;
                    }

                    double amount = double.parse(_amountController.text);

                    if (amount <= 0) {
                      Get.snackbar(
                        "Error",
                        "Please enter valid value of amount",
                        colorText: headingText,
                        backgroundColor: error,
                      );
                      return;
                    }

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? token = prefs.getString('token');
                    String finalToken = "Bearer $token";

                    setState(() {
                      isLoading = true;
                    });

                    balanceController = Get.put(BalanceController(
                        widget.currentBalance, amount, _typeController.text));

                    balanceController.updatebalance();

                    final AddReportRequest addReport = AddReportRequest(
                      title: _titleController.text,
                      merchantName: _merchantNameController.text,
                      description: _descriptionController.text,
                      date: _dateController.text,
                      type: _typeController.text,
                      category: _categoryController.text,
                      amount: amount,
                      billImage: _billImageController.text.isEmpty
                          ? 'https://as2.ftcdn.net/v2/jpg/09/66/81/65/1000_F_966816564_hcfsJsf7EjKOs5gFfIx8ihMrs5I7fNfP.jpg'
                          : _billImageController.text,
                    );
                    restClient
                        .addReport(finalToken, addReport)
                        .then((response) {
                      setState(() {
                        isLoading = false;
                      });
                      debugPrint(response.toString());
                      Get.snackbar(
                        "Success",
                        response.message,
                        colorText: headingText,
                        backgroundColor: success,
                      );

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigationBarr(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }).catchError((error) {
                      setState(() {
                        isLoading = false;
                      });
                      String errorMessage =
                          "Something went wrong. Please try again.";
                      if (error is DioException) {
                        if (error.response?.data != null &&
                            error.response?.data is Map) {
                          errorMessage =
                              error.response?.data['message'] ?? errorMessage;
                        }
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
                ),
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }
}
