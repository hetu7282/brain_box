import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/block_model.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/get_piece_path.dart';
import 'package:flutter/material.dart';

class JigsawPainterBackground extends CustomPainter {
  JigsawPainterBackground(
    this.blocks, {
    required this.outlineCanvas,
    this.borderRadius,
    this.color,
  });

  List<BlockClass> blocks;
  bool outlineCanvas;
  double? borderRadius;
  Color? color;

  @override
  void paint(Canvas canvas, Size size) {

    final Paint paint = Paint()
      ..style = outlineCanvas ? PaintingStyle.stroke : PaintingStyle.fill
      ..color = color ?? AppColor.k7FC2F4.withOpacityValue(0.5)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final Path path = Path();

    for (var element in blocks) {
      final double radius =
          borderRadius ?? element.jigsawBlockWidget.imageBox.radiusPoint;

      final Path pathTemp = getPiecePath(
        element.jigsawBlockWidget.imageBox.size,
        radius,
        element.jigsawBlockWidget.imageBox.offsetCenter,
        element.jigsawBlockWidget.imageBox.posSide,
      );

      path.addPath(pathTemp, element.offsetDefault);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
