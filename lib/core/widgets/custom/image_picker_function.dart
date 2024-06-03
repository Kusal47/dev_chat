import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> uploadImageFromGallery(BuildContext context,ImageSource imageSource) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source:imageSource);

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}
