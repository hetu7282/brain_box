// ignore_for_file: library_private_types_in_public_api

import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_blok_painter.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/puzzle_piece_clipper.dart';
import 'package:flutter/material.dart';

import 'image_box_model.dart';

class JigsawBlockWidget extends StatefulWidget {
  const JigsawBlockWidget({super.key, required this.imageBox});

  final ImageBox imageBox;

  @override
  _JigsawBlockWidgetState createState() => _JigsawBlockWidgetState();
}

class _JigsawBlockWidgetState extends State<JigsawBlockWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PuzzlePieceClipper(imageBox: widget.imageBox),
      child: CustomPaint(
        foregroundPainter: JigsawBlokPainter(imageBox: widget.imageBox),
        child: widget.imageBox.image,
      ),
    );
  }
}
