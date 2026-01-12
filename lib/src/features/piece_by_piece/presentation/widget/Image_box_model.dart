import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_pos_model.dart';
import 'package:flutter/material.dart';

class ImageBox {
  ImageBox({
    required this.image,
    required this.posSide,
    required this.isDone,
    required this.offsetCenter,
    required this.radiusPoint,
    required this.size,
  });

  Widget image;
  ClassJigsawPos posSide;
  Offset offsetCenter;
  Size size;
  double radiusPoint;
  bool isDone;
}
