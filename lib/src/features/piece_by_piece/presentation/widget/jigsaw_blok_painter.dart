import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/get_piece_path.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/image_box_model.dart';
import 'package:flutter/material.dart';

class JigsawBlokPainter extends CustomPainter {
  JigsawBlokPainter({required this.imageBox});

  ImageBox imageBox;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = imageBox.isDone
          ? AppColor.white.withOpacityValue(0)
          : AppColor.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(
      getPiecePath(
        size,
        imageBox.radiusPoint,
        imageBox.offsetCenter,
        imageBox.posSide,
      ),
      paint,
    );

    if (imageBox.isDone) {
      final Paint paintDone = Paint()
        ..color = Colors.white.withOpacityValue(0)
        ..style = PaintingStyle.fill
        ..strokeWidth = 2;
      canvas.drawPath(
        getPiecePath(
          size,
          imageBox.radiusPoint,
          imageBox.offsetCenter,
          imageBox.posSide,
        ),
        paintDone,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
