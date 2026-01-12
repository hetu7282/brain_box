import 'dart:io';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/permission_dialog.dart';
import 'device_info_service.dart';

class PermissionService {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    Permission permission = Permission.camera;
    bool isGranted = await _checkPermmisionIsGranted(permission);
    if (isGranted) return true;
    if (!context.mounted) return false;
    final status = await requestPermission(
      context: context,
      permission: permission,
      title: 'Camera Permission Denied',
      message: 'Please grant permission to continue',
    );
    return status;
  }

  static Future<bool> requestGalleryPermission(BuildContext context) async {
    late Permission permission;
    if (Platform.isAndroid) {
      int sdk = await DeviceInfoService.getSdk();
      if (sdk <= 32) {
        permission = Permission.storage;
      } else {
        return true;
      }
    } else {
      permission = Permission.photos;
    }
    bool isGranted = await _checkPermmisionIsGranted(permission);
    if (isGranted) return true;
    if (!context.mounted) return false;
    final status = await requestPermission(
      context: context,
      permission: permission,
      title: 'Gallery Permission Denied',
      message: 'Please grant permission to continue',
    );
    return status;
  }

  static Future<bool> requestPermission({
    required BuildContext context,
    required Permission permission,
    String? title,
    String? message,
  }) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) {
      return true;
    }
    if (status == PermissionStatus.denied) {
      return false;
    }
    if (status == PermissionStatus.permanentlyDenied) {
      if (!context.mounted) return false;
      showPermissionDeniedBottomSheet(
        context,
        title: title ?? 'Permission Denied',
        message:
            message ??
            'Please grant permission to continue',
      );
    }
    return false;
  }

  static Future<bool> _checkPermmisionIsGranted(Permission permission) async {
    bool isGranted = await permission.isGranted;
    return isGranted;
  }

  static Future<void> showPermissionDeniedBottomSheet(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.black12,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: PermissionDialog(title: title, message: message),
          ),
        );
      },
    );
  }
}
