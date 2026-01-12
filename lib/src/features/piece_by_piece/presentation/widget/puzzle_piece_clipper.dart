


import 'package:flutter/material.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/image_box_model.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/get_piece_path.dart';

class PuzzlePieceClipper extends CustomClipper<Path> {
  PuzzlePieceClipper({
    required this.imageBox,
  });

  ImageBox imageBox;

  @override
  Path getClip(Size size) {
    return getPiecePath(
        size, imageBox.radiusPoint, imageBox.offsetCenter, imageBox.posSide);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
