import 'dart:io';

import 'package:echat/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// Future<File?> pickImage(BuildContext context) async {
//   File? imageFile;
//   try {
//     final pickedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       imageFile = File(pickedImage.path);
//     }
//   } catch (e) {
//     showSnackbar(context, e.toString());
//     print(e.toString());
//   }
//   return imageFile;
// }

Future<File?> pickImage(BuildContext context) async {
  File? imageFile;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
    }
  } on PlatformException catch (e) {
    // Specific handling for PlatformException
    showSnackbar(context, "Failed to pick image: ${e.message}");
    print("PlatformException: ${e.message}");
  } catch (e) {
    // Generic error handling
    showSnackbar(context, "An error occurred: $e");
    print("Error: $e");
  }
  return imageFile;
}
