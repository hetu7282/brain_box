import 'package:brain_box/src/core/utils/enums.dart';
import 'package:brain_box/src/core/widgets/loader.dart';
import 'package:brain_box/src/core/widgets/refresh.dart';
import 'package:flutter/material.dart';

class DataLoadingWidget extends StatelessWidget {
  const DataLoadingWidget({
    super.key,
    required this.status,
    required this.callback,
    required this.child,
    this.addBottomPadding = true,
  });

  final FormzStatus status;
  final VoidCallback callback;
  final Widget child;
  final bool addBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        switch (status) {
          case FormzStatus.failed:
            return Padding(
              padding: EdgeInsets.only(
                bottom: (!addBottomPadding)
                    ? 0
                    : MediaQuery.of(context).padding.bottom,
              ),
              child: Refresh(onRefresh: callback),
            );
          case FormzStatus.success:
            return child;
          default:
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: (!addBottomPadding)
                      ? 0
                      : MediaQuery.of(context).padding.bottom,
                ),
                child: Loader(),
              ),
            );
        }
      },
    );
  }
}
