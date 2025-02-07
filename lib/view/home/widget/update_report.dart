// ignore_for_file: must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously

import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/client/rest_client.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/controller/image_controller.dart';
import 'package:aether_wallet/models/categories_response.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:aether_wallet/models/update_report_request.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';

class UpdateReport extends StatefulWidget {
  final Report report;
  final List<Category> categories;

  const UpdateReport(
      {super.key, required this.report, required this.categories});

  @override
  State<UpdateReport> createState() => _UpdateReportState();
}

class _UpdateReportState extends State<UpdateReport> {
  final ImageController _imageController = Get.put(ImageController());
  final Dio _dio = Dio();
  late RestClient _apiClient;

  bool isUpdating = false;
  bool imageUploading = false;

  Category? selectedCategory;
  String? selectedType;

  late List<Category> filteredCategories;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _merchantNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _billImageController = TextEditingController();

  List<String> types = ["Income", "Expense"];

  @override
  void initState() {
    super.initState();
    _apiClient = RestClient(_dio);

    // Pre-fill existing report details
    _titleController.text = widget.report.title;
    _merchantNameController.text = widget.report.merchantName;
    _descriptionController.text = widget.report.description;
    _dateController.text = widget.report.date;
    _amountController.text = widget.report.amount.toString();
    _billImageController.text = widget.report.billImage;

    // Set default values for dropdowns
    selectedCategory = widget.categories.firstWhere(
        (category) => category.id == widget.report.categories.id,
        orElse: () => widget.categories.first);

    selectedType = widget.report.reportType;

    // Filter categories based on report type
    _filterCategories(selectedType);
  }

  void _filterCategories(String? type) {
    setState(() {
      filteredCategories =
          widget.categories.where((category) => category.type == type).toList();
      // Ensure selectedCategory belongs to the filtered list
      if (!filteredCategories.contains(selectedCategory)) {
        selectedCategory =
            filteredCategories.isNotEmpty ? filteredCategories.first : null;
      }
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _titleController.dispose();
    _merchantNameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _billImageController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    await _imageController.selectImage(ImageSource.gallery);

    if (_imageController.selectedImage == null) {
      debugPrint("No image selected.");
      return;
    }

    setState(() {
      imageUploading = true;
    });

    try {
      await _imageController.uploadImageToCloudinary();

      if (_imageController.imageUrl != null &&
          _imageController.imageUrl!.isNotEmpty) {
        _billImageController.text = _imageController.imageUrl!;
        Get.snackbar("Success", "Image uploaded successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        throw "Image upload failed. Please try again.";
      }
    } catch (error) {
      Get.snackbar("Error", error.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        imageUploading = false;
      });
    }
  }

  Future<void> _updateReport() async {
    if (isUpdating) return;

    setState(() {
      isUpdating = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        throw "User token is missing. Please log in again.";
      }

      if (widget.report.id.isEmpty) {
        throw "Report ID is missing.";
      }

      if (_titleController.text.isEmpty ||
          _merchantNameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _dateController.text.isEmpty ||
          selectedType == null ||
          selectedCategory == null ||
          _amountController.text.isEmpty) {
        Get.snackbar("Error", "Please fill all the details",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      double? amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        Get.snackbar("Error", "Enter a valid amount",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      UpdateReportRequest updateRequest = UpdateReportRequest(
        id: widget.report.id,
        title: _titleController.text.trim(),
        merchantName: _merchantNameController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _dateController.text.trim(),
        type: selectedType!,
        category: selectedCategory!.id, // ✅ Send Category ID instead of object
        amount: amount,
        billImage: _billImageController.text.trim(),
      );

      _apiClient.updatereport("Bearer $token", updateRequest).then((response) {
        setState(() {
          isUpdating = false;
        });

        Get.snackbar("Success", "Report updated successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAll(() => BottomNavigationBarr());
      }).catchError((error) {
        setState(() {
          isUpdating = false;
        });

        Get.snackbar("Error", "Failed to update report: ${error.toString()}",
            backgroundColor: Colors.red, colorText: Colors.white);
      });
    } catch (error) {
      setState(() {
        isUpdating = false;
      });

      Get.snackbar("Error", "An unexpected error occurred: ${error.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: headingText),
        ),
        backgroundColor: appBar,
        centerTitle: true,
        title: ReusableText(
          text: "Update Report",
          color: headingText,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
          letterSpace: 1.5,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            _buildField("Title", _titleController, LineIcons.heading),
            _buildField(
                "Merchant Name", _merchantNameController, LineIcons.userAlt),
            _buildField(
                "Description", _descriptionController, LineIcons.paragraph),
            _buildField("Date", _dateController, LineIcons.calendar),
            _buildDropdown<String>("Type", selectedType, types, (value) {
              setState(() {
                selectedType = value;
                _filterCategories(value);
              });
            }, (type) => type), // ✅ Passed the missing 5th argument
            SizedBox(height: 12.h),
            _buildDropdown<Category>(
                "Category", selectedCategory, filteredCategories, (value) {
              setState(() => selectedCategory = value);
            },
                (category) =>
                    category.name), // ✅ Now properly extracts category name
            SizedBox(height: 12.h),
            _buildField("Amount", _amountController, LineIcons.moneyBill),
            SizedBox(height: 12.h),
            ReusableText(
                text: "Bill Image:", fontSize: 18.sp, letterSpace: 1.4),
            GestureDetector(
              onTap: _uploadImage,
              child: imageUploading
                  ? Center(child: CircularProgressIndicator(color: headingText))
                  : _billImageController.text.isEmpty
                      ? _buildUploadBox()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            _billImageController.text,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
            ),
            SizedBox(height: 12.h),

            ReusableButton(
                text: "Update Report",
                icon: LineIcons.save,
                onTap: _updateReport),
            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String label, T? value, List<T> items,
      ValueChanged<T?> onChanged, String Function(T) getLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: label,
          fontSize: 18.sp,
          letterSpace: 1.4,
        ),
        SizedBox(height: 6.h),
        DropdownButtonFormField<T>(
          dropdownColor: lightBackground,
          icon: Icon(Icons.keyboard_arrow_down_outlined),
          iconSize: 32.sp,
          iconEnabledColor: headingText,
          iconDisabledColor: headingText,
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
          value: value,
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
          // decoration: InputDecoration(labelText: label),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: ReusableText(
                text: getLabel(item),
                fontSize: 17.sp,
                letterSpace: 1.3,
              ), // ✅ Extracts label correctly
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildField(
      String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(text: "$label:", fontSize: 18.sp, letterSpace: 1.4),
        SpecialTextfield(text: label, Icondata: icon, controller: controller),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildUploadBox() => DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12.r),
        color: headingText,
        strokeWidth: 1,
        child: SizedBox(height: 150, width: double.infinity),
      );
}
