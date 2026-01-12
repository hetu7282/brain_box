import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

class SnackBarService {
  static void showErrorSnackBar(BuildContext context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      description: CustomText(text: message, fontSize: 15.px),
      dragToClose: true,
      closeOnClick: true,
      dismissDirection: DismissDirection.down,
    );
  }

  static void showSuccessSnackBar(context, String message) {
    toastification.dismissAll();
    toastification.show(
      context: context,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      description: CustomText(text: message, fontSize: 15.px),
      dragToClose: true,
      closeOnClick: true,
      dismissDirection: DismissDirection.down,
    );
  }

  static void showInfoSnackBar(context, String message) {
    toastification.show(
      context: context,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),

      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      description: CustomText(text: message, fontSize: 15.px),
      dragToClose: true,
      closeOnClick: true,
      dismissDirection: DismissDirection.down,
    );
  }
}
