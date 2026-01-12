import 'package:brain_box/src/features/piece_by_piece/presentation/widget/calculate_point.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_pos_model.dart';
import 'package:flutter/material.dart';

Path getPiecePath(
  Size size,
  double radiusPoint,
  Offset offsetCenter,
  ClassJigsawPos posSide,
) {
  final Path path = Path();

  Offset topLeft = const Offset(0, 0);
  Offset topRight = Offset(size.width, 0);
  Offset bottomLeft = Offset(0, size.height);
  Offset bottomRight = Offset(size.width, size.height);

  topLeft =
      Offset(
        posSide.left > 0 ? radiusPoint : 0,
        (posSide.top > 0) ? radiusPoint : 0,
      ) +
      topLeft;
  topRight =
      Offset(
        posSide.right > 0 ? -radiusPoint : 0,
        (posSide.top > 0) ? radiusPoint : 0,
      ) +
      topRight;
  bottomRight =
      Offset(
        posSide.right > 0 ? -radiusPoint : 0,
        (posSide.bottom > 0) ? -radiusPoint : 0,
      ) +
      bottomRight;
  bottomLeft =
      Offset(
        posSide.left > 0 ? radiusPoint : 0,
        (posSide.bottom > 0) ? -radiusPoint : 0,
      ) +
      bottomLeft;

  final double topMiddle = posSide.top == 0
      ? topRight.dy
      : (posSide.top > 0
            ? topRight.dy - radiusPoint
            : topRight.dy + radiusPoint);

  final double bottomMiddle = posSide.bottom == 0
      ? bottomRight.dy
      : (posSide.bottom > 0
            ? bottomRight.dy + radiusPoint
            : bottomRight.dy - radiusPoint);

  final double leftMiddle = posSide.left == 0
      ? topLeft.dx
      : (posSide.left > 0
            ? topLeft.dx - radiusPoint
            : topLeft.dx + radiusPoint);

  final double rightMiddle = posSide.right == 0
      ? topRight.dx
      : (posSide.right > 0
            ? topRight.dx + radiusPoint
            : topRight.dx - radiusPoint);

  path.moveTo(topLeft.dx, topLeft.dy);

  if (posSide.top != 0) {
    path.extendWithPath(
      calculatePoint(
        Axis.horizontal,
        topLeft.dy,
        Offset(offsetCenter.dx, topMiddle),
        radiusPoint,
      ),
      Offset.zero,
    );
  }
  path.lineTo(topRight.dx, topRight.dy);

  if (posSide.right != 0) {
    path.extendWithPath(
      calculatePoint(
        Axis.vertical,
        topRight.dx,
        Offset(rightMiddle, offsetCenter.dy),
        radiusPoint,
      ),
      Offset.zero,
    );
  }
  path.lineTo(bottomRight.dx, bottomRight.dy);

  if (posSide.bottom != 0) {
    path.extendWithPath(
      calculatePoint(
        Axis.horizontal,
        bottomRight.dy,
        Offset(offsetCenter.dx, bottomMiddle),
        -radiusPoint,
      ),
      Offset.zero,
    );
  }
  path.lineTo(bottomLeft.dx, bottomLeft.dy);

  if (posSide.left != 0) {
    path.extendWithPath(
      calculatePoint(
        Axis.vertical,
        bottomLeft.dx,
        Offset(leftMiddle, offsetCenter.dy),
        -radiusPoint,
      ),
      Offset.zero,
    );
  }
  path.lineTo(topLeft.dx, topLeft.dy);

  path.close();

  return path;
}
