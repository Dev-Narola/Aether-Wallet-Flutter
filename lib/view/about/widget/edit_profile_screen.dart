// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:aether_wallet/bottom_navigation_barr.dart';
import 'package:aether_wallet/client/rest_client.dart';
import 'package:aether_wallet/common/loading_screen.dart';
import 'package:aether_wallet/controller/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:aether_wallet/common/reusable_button.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aether_wallet/models/update_user_request.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImageController _imageController = Get.put(ImageController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final Dio _dio = Dio();
  late RestClient _apiClient;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData['name'] ?? "";
    _emailController.text = widget.userData['email'] ?? "";
    _phoneController.text = widget.userData['mobile_no'] ?? "";
    _apiClient = RestClient(_dio);
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("iamge ----------------> ${_imageController.selectedImage}");
      if (_imageController.selectedImage != null) {
        await _imageController.uploadImageToCloudinary();
      }

      String updatedImageUrl =
          _imageController.imageUrl ?? widget.userData['user_image'] ?? "";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        Get.snackbar("Error", "User token is missing. Please log in again.",
            backgroundColor: Colors.red, colorText: Colors.white);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String finalToken = "Bearer $token";

      UpdateUserRequest updateUserRequest = UpdateUserRequest(
        name: _nameController.text,
        email: _emailController.text,
        mobile_no: _phoneController.text,
        password: widget.userData['password'] ?? "",
        user_image: updatedImageUrl,
      );

      _apiClient.updateUser(finalToken, updateUserRequest).then((response) {
        setState(() {
          _isLoading = false;
        });

        Get.snackbar("Success", response.message,
            backgroundColor: Colors.green, colorText: Colors.white);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavigationBarr()),
        );
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar("Error", "An error occurred: ${error.toString()}",
            backgroundColor: Colors.red, colorText: Colors.white);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Get.snackbar("Error", "An unexpected error occurred: $e",
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
        title: typeWriterAnimatedText(
          text: "Update Profile",
          color: headingText,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
          letterSpace: 1.5,
        ),
      ),
      body: _isLoading
          ? Center(
              // Ensures proper size constraint
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: LoadingScreen(),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Center(
                      child: GetBuilder<ImageController>(
                        builder: (controller) {
                          return Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 110.r,
                                backgroundColor: lightBackground,
                                backgroundImage: controller.selectedImage !=
                                        null
                                    ? FileImage(controller.selectedImage!)
                                    : (widget.userData['user_image'] != null &&
                                                widget.userData['user_image']
                                                    .isNotEmpty
                                            ? NetworkImage(
                                                widget.userData['user_image'])
                                            : AssetImage(
                                                "assets/default_avatar.png"))
                                        as ImageProvider,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    controller.selectImage(ImageSource.gallery),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: headingText,
                                  ),
                                  child: Icon(LineIcons.camera,
                                      color: lightBackground, size: 18),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ReusableText(text: "Name"),
                    SpecialTextfield(
                      text: "Name",
                      controller: _nameController,
                      Icondata: LineIcons.userCircle,
                    ),
                    SizedBox(height: 10.h),
                    ReusableText(text: "Email"),
                    SpecialTextfield(
                      text: "Email",
                      controller: _emailController,
                      Icondata: LineIcons.mailchimp,
                    ),
                    SizedBox(height: 10.h),
                    ReusableText(text: "Mobile No."),
                    SpecialTextfield(
                      text: "Mobile No.",
                      controller: _phoneController,
                      Icondata: LineIcons.phone,
                    ),
                    SizedBox(height: 40.h),
                    ReusableButton(
                      text: "Save Profile",
                      icon: LineIcons.save,
                      onTap: _saveProfile,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
