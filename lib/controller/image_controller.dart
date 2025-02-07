import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class ImageController extends GetxController {
  File? selectedImage;
  String? imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> selectImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        update(); // Notify GetX listeners
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> uploadImageToCloudinary() async {
    if (selectedImage == null) return;

    String cloudName = "ddl7jfvpu";
    String uploadPreset = "Aether-Wallet";
    String uploadUrl =
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.fields['upload_preset'] = uploadPreset;
      request.files
          .add(await http.MultipartFile.fromPath('file', selectedImage!.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        imageUrl = jsonResponse['secure_url'];
        debugPrint("Image uploaded successfully: $imageUrl");
        update(); // Notify GetX listeners
      } else {
        debugPrint(
            "Cloudinary upload failed: ${jsonResponse['error']['message']}");
      }
    } catch (e) {
      debugPrint("Error uploading image: $e");
    }
  }

  void clearImage() {
    selectedImage = null;
    imageUrl = null;
    update();
  }
}
