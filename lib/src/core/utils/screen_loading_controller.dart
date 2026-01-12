
import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:flutter/material.dart';

typedef Show = bool Function();
typedef Hide = bool Function();

class LoadingController {
  final Show show;
  final Hide hide;

  const LoadingController({required this.show, required this.hide});
}

class ScreenLoadingController {
  ScreenLoadingController._();

  static final ScreenLoadingController _instance = ScreenLoadingController._();

  LoadingController? _controller;

  static ScreenLoadingController get instance => _instance;

  void show({Color? loadingColor, Color? containerColor, Color? backgroundColor}) {
    if (_controller?.show() ?? false) {
      return;
    } else {
      _controller = _showLoading(
        loadingColor: loadingColor,
        containerColor: containerColor,
        backgroundColor: backgroundColor,
      );
    }
  }

  void hide() {
    _controller?.hide();
    _controller = null;
  }

  _showLoading({Color? loadingColor, Color? containerColor, Color? backgroundColor}) {
    final state = AppRouterNavigationKey.navigatorKey.currentState!.overlay!;
    final entry = OverlayEntry(
      builder: (context) {
        return Material(
          color: backgroundColor ?? Colors.black.withAlpha(125),
          child: Center(
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: containerColor ?? AppColor.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: SizedBox(height: 30, width: 30, child: const CircularProgressIndicator())),
            ),
          ),
        );
      },
    );

    state.insert(entry);

    return LoadingController(
      show: () {
        return true;
      },
      hide: () {
        entry.remove();
        return true;
      },
    );
  }
}
