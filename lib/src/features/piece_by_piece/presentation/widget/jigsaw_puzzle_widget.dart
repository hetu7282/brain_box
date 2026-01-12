// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_widget.dart';
import 'package:flutter/material.dart';

class JigsawPuzzle extends StatefulWidget {
  JigsawPuzzle({
    super.key,
    required this.gridSize,
    required this.puzzleKey,
    required this.jigImage,
    required this.image,
    this.onFinished,
    this.onBlockSuccess,
    this.onProgressUpdate,
    this.outlineCanvas = true,
    this.autoStart = false,
    this.snapSensitivity = .5,
    this.borderRadius,
    this.showBackgroundImage = false,
  });

  final int gridSize;
  final Function()? onFinished;
  final Function()? onBlockSuccess;
  final Function(int placedCount, int totalCount)? onProgressUpdate;
  final ImageProvider image;
  final bool autoStart;
  final bool outlineCanvas;
  final double snapSensitivity;
  final double? borderRadius;
  final bool showBackgroundImage;
  String jigImage;
  final GlobalKey<JigsawWidgetState> puzzleKey;

  @override
  _JigsawPuzzleState createState() => _JigsawPuzzleState();
}

class _JigsawPuzzleState extends State<JigsawPuzzle> {
  @override
  Widget build(BuildContext context) {
    return JigsawWidget(
      jigImage: widget.jigImage,
      callbackFinish: () {
        if (widget.onFinished != null) {
          widget.onFinished!();
        }
      },
      callbackSuccess: () {
        if (widget.onBlockSuccess != null) {
          widget.onBlockSuccess!();
        }
      },
      onProgressUpdate: widget.onProgressUpdate,
      key: widget.puzzleKey,
      gridSize: widget.gridSize,
      snapSensitivity: widget.snapSensitivity,
      outlineCanvas: widget.outlineCanvas,
      borderRadius: widget.borderRadius,
      showBackgroundImage: widget.showBackgroundImage,
      child: Image(fit: BoxFit.fill, image: widget.image),
    );
  }
}
