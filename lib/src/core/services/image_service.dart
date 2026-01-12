import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:brain_box/src/core/services/permission_service.dart';
import 'package:brain_box/src/core/services/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> pickImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    late bool isGranted;
    if (source == ImageSource.gallery) {
      isGranted = await PermissionService.requestGalleryPermission(context);
    } else {
      isGranted = await PermissionService.requestCameraPermission(context);
    }
    if (!isGranted) {
      return null;
    }

    XFile? file = await _imagePicker.pickImage(source: source);
    if (file == null) return null;
    bool isSVG = file.path.endsWith('.svg');
    if (isSVG && context.mounted) {
      SnackBarService.showErrorSnackBar(context, "SVG files are not supported");
      return null;
    }
    return File(file.path);
  }

  static Future<List<File>?> pickMultipleImage({
    required BuildContext context,
  }) async {
    late bool isGranted;
    isGranted = await PermissionService.requestGalleryPermission(context);
    if (!isGranted) return null;
    List<XFile>? file = await _imagePicker.pickMultiImage(limit: 5);
    if (file.isEmpty) return null;
    return file.map((e) => File(e.path)).toList();
  }

  static Future<Uint8List?> pickImageAsUint8List({
    required BuildContext context,
    required ImageSource source,
  }) async {
    File? file = await pickImage(context: context, source: source);
    if (file == null) return null;
    final byte = file.readAsBytesSync();
    return byte;
  }

  static Future<String?> pickImageAsBase64({
    required BuildContext context,
    required ImageSource source,
  }) async {
    Uint8List? byte = await pickImageAsUint8List(
      context: context,
      source: source,
    );
    if (byte == null) return null;
    return base64Encode(byte);
  }
}
