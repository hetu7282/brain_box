// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/block_model.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/image_box_model.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/invalid_image_exception.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_block_widget.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_painter_background.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_pos_model.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as ui;
import 'package:sizer/sizer.dart';

class JigsawWidget extends StatefulWidget {
  const JigsawWidget({
    super.key,
    required this.gridSize,
    required this.snapSensitivity,
    required this.child,
    required this.jigImage,
    this.callbackFinish,
    this.callbackSuccess,
    this.onProgressUpdate,
    this.outlineCanvas = true,
    this.borderRadius,
    this.showBackgroundImage = false,
  });

  final Widget child;
  final Function()? callbackSuccess;
  final Function()? callbackFinish;
  final Function(int placedCount, int totalCount)? onProgressUpdate;
  final int gridSize;
  final bool outlineCanvas;
  final double snapSensitivity;
  final String jigImage;
  final double? borderRadius;
  final bool showBackgroundImage;

  @override
  JigsawWidgetState createState() => JigsawWidgetState();
}

class JigsawWidgetState extends State<JigsawWidget> {
  final GlobalKey _globalKey = GlobalKey();
  ui.Image? fullImage;
  Size? size;

  List<List<BlockClass>> images = <List<BlockClass>>[];
  ValueNotifier<List<BlockClass>> blocksNotifier =
      ValueNotifier<List<BlockClass>>(<BlockClass>[]);

  Offset _pos = Offset.zero;
  int? _index;

  Future<ui.Image?> _getImageFromWidget() async {
    final context = _globalKey.currentContext;
    if (context == null) {
      throw InvalidImageException();
    }

    final renderObject = context.findRenderObject();
    if (renderObject == null || renderObject is! RenderRepaintBoundary) {
      throw InvalidImageException();
    }

    final RenderRepaintBoundary boundary = renderObject;

    // size = Platform.isMacOS ? boundary.size * 200 : boundary.size;
    size = boundary.size;
    final img = await boundary.toImage();
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes == null) {
      throw InvalidImageException();
    }
    return ui.decodeImage(pngBytes);
  }

  void reset() {
    images.clear();
    blocksNotifier = ValueNotifier<List<BlockClass>>(<BlockClass>[]);
    blocksNotifier.notifyListeners();
    setState(() {});
  }

  Future<void> generate() async {
    images = [[]];

    fullImage ??= await _getImageFromWidget();

    if (fullImage == null) {
      return;
    }

    final int xSplitCount = widget.gridSize;
    final int ySplitCount = widget.gridSize;

    final double widthPerBlock = fullImage!.width / xSplitCount;
    final double heightPerBlock = fullImage!.height / ySplitCount;

    for (var y = 0; y < ySplitCount; y++) {
      final tempImages = <BlockClass>[];

      images.add(tempImages);
      for (var x = 0; x < xSplitCount; x++) {
        final int randomPosRow = math.Random().nextInt(2).isEven ? 1 : -1;
        final int randomPosCol = math.Random().nextInt(2).isEven ? 1 : -1;

        Offset offsetCenter = Offset(widthPerBlock / 2, heightPerBlock / 2);

        final ClassJigsawPos jigsawPosSide = ClassJigsawPos(
          bottom: y == ySplitCount - 1 ? 0 : randomPosCol,
          left: x == 0
              ? 0
              : -images[y][x - 1].jigsawBlockWidget.imageBox.posSide.right,
          right: x == xSplitCount - 1 ? 0 : randomPosRow,
          top: y == 0
              ? 0
              : -images[y - 1][x].jigsawBlockWidget.imageBox.posSide.bottom,
        );

        double xAxis = widthPerBlock * x;
        double yAxis = heightPerBlock * y;

        final double minSize = math.min(widthPerBlock, heightPerBlock) / 15 * 4;

        offsetCenter = Offset(
          (widthPerBlock / 2) + (jigsawPosSide.left == 1 ? minSize : 0),
          (heightPerBlock / 2) + (jigsawPosSide.top == 1 ? minSize : 0),
        );

        xAxis -= jigsawPosSide.left == 1 ? minSize : 0;
        yAxis -= jigsawPosSide.top == 1 ? minSize : 0;

        final double widthPerBlockTemp =
            widthPerBlock +
            (jigsawPosSide.left == 1 ? minSize : 0) +
            (jigsawPosSide.right == 1 ? minSize : 0);
        final double heightPerBlockTemp =
            heightPerBlock +
            (jigsawPosSide.top == 1 ? minSize : 0) +
            (jigsawPosSide.bottom == 1 ? minSize : 0);

        final ui.Image temp = ui.copyCrop(
          fullImage!,
          y: yAxis.round(),
          width: widthPerBlockTemp.round(),
          height: heightPerBlockTemp.round(),
          x: xAxis.round(),
        );

        if (size == null) {
          continue;
        }

        final Offset offset = Offset(
          size!.width / 2 - widthPerBlockTemp / 2,
          size!.height / 2 - heightPerBlockTemp / 2,
        );

        final ImageBox imageBox = ImageBox(
          image: Image.memory(
            Uint8List.fromList(ui.encodePng(temp)),
            fit: BoxFit.contain,
          ),
          isDone: false,
          offsetCenter: offsetCenter,
          posSide: jigsawPosSide,
          radiusPoint: widget.borderRadius ?? minSize,
          size: Size(widthPerBlockTemp, heightPerBlockTemp),
        );

        images[y].add(
          BlockClass(
            jigsawBlockWidget: JigsawBlockWidget(imageBox: imageBox),
            offset: offset,
            offsetDefault: Offset(xAxis, yAxis),
          ),
        );
      }
    }

    blocksNotifier.value = images.expand((image) => image).toList();
    blocksNotifier.value.shuffle();
    blocksNotifier.notifyListeners();

    // Initialize progress when puzzle is generated
    final totalPieces = blocksNotifier.value.length;
    final placedPieces = blocksNotifier.value
        .where((block) => block.jigsawBlockWidget.imageBox.isDone)
        .length;
    widget.onProgressUpdate?.call(placedPieces, totalPieces);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return ValueListenableBuilder(
      valueListenable: blocksNotifier,
      builder: (context, List<BlockClass> blocks, child) {
        final List<BlockClass> blockNotDone = blocks
            .where((block) => !block.jigsawBlockWidget.imageBox.isDone)
            .toList();
        final List<BlockClass> blockDone = blocks
            .where((block) => block.jigsawBlockWidget.imageBox.isDone)
            .toList();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Listener(
                    onPointerUp: (event) {
                      if (blockNotDone.isEmpty) {
                        reset();
                        widget.callbackFinish?.call();
                      }
                    },
                    onPointerMove: (event) {
                      if (_index == null) {
                        return;
                      }
                      if (blockNotDone.isEmpty) {
                        return;
                      }

                      final Offset offset = event.localPosition - _pos;

                      blockNotDone[_index!].offset = offset;

                      const minSensitivity = 0;
                      const maxSensitivity = 1;
                      const maxDistanceThreshold = 20;
                      const minDistanceThreshold = 1;

                      final sensitivity = widget.snapSensitivity;
                      final distanceThreshold =
                          sensitivity *
                              (maxSensitivity - minSensitivity) *
                              (maxDistanceThreshold - minDistanceThreshold) +
                          minDistanceThreshold;

                      if ((blockNotDone[_index!].offset -
                                  blockNotDone[_index!].offsetDefault)
                              .distance <
                          distanceThreshold) {
                        blockNotDone[_index!]
                                .jigsawBlockWidget
                                .imageBox
                                .isDone =
                            true;

                        blockNotDone[_index!].offset =
                            blockNotDone[_index!].offsetDefault;

                        _index = null;

                        blocksNotifier.notifyListeners();

                        // Update progress
                        final totalPieces = blocks.length;
                        final placedPieces = blocks
                            .where(
                              (block) =>
                                  block.jigsawBlockWidget.imageBox.isDone,
                            )
                            .length;
                        widget.onProgressUpdate?.call(
                          placedPieces,
                          totalPieces,
                        );

                        widget.callbackSuccess?.call();
                      }

                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        if (blocks.isEmpty) ...[
                          RepaintBoundary(
                            key: _globalKey,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.px),
                              child: SizedBox(
                                height: double.maxFinite,
                                width: double.maxFinite,
                                child: widget.child,
                              ),
                            ),
                          ),
                        ],
                        Offstage(
                          offstage: blocks.isEmpty,
                          child: Container(
                            width: size?.width,
                            height: size?.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.px),
                              color: themeState.textOnboardingBackgroundColor!,
                              image: widget.showBackgroundImage
                                  ? DecorationImage(
                                      image: AssetImage(widget.jigImage),
                                      fit: BoxFit.fill,
                                      opacity: 0.6,
                                    )
                                  : null,
                            ),
                            child: CustomPaint(
                              painter: JigsawPainterBackground(
                                blocks,
                                outlineCanvas: widget.outlineCanvas,
                                borderRadius: widget.borderRadius,
                                color: themeState
                                    .jigsawPainterBackgroundBorderColor!
                                    .withOpacityValue(0.5),
                              ),
                              child: Stack(
                                children: [
                                  if (blockDone.isNotEmpty)
                                    ...blockDone.map((map) {
                                      return Positioned(
                                        left: map.offset.dx,
                                        top: map.offset.dy,
                                        child: Container(
                                          child: map.jigsawBlockWidget,
                                        ),
                                      );
                                    }),
                                  if (blockNotDone.isNotEmpty)
                                    ...blockNotDone.asMap().entries.map((map) {
                                      return Positioned(
                                        left: map.value.offset.dx,
                                        top: map.value.offset.dy,
                                        child: Offstage(
                                          offstage: !(_index == map.key),
                                          child: GestureDetector(
                                            onTapDown: (details) {
                                              if (map
                                                  .value
                                                  .jigsawBlockWidget
                                                  .imageBox
                                                  .isDone) {
                                                return;
                                              }

                                              setState(() {
                                                _pos = details.localPosition;
                                                _index = map.key;
                                              });
                                            },
                                            child: Container(
                                              child:
                                                  map.value.jigsawBlockWidget,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (blockNotDone.isNotEmpty) ...[
                CustomText(
                  text: 'Available Pieces:',
                  color: themeState.splashLogoColor!,
                  fontSize: 16.px,
                  fontWeight: FontWeight.w500,
                ),
                GapH(10.px),
                Container(
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: themeState
                        .settingCustomContainerColor!, // Dark blue background
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: themeState.settingCustomContainerBorderColor!
                          .withOpacityValue(0.5), // Light blue border
                      width: 1,
                    ),
                  ),
                  child: SizedBox(
                    height: 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: blockNotDone.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final block = entry.value;
                          final Size sizeBlock =
                              block.jigsawBlockWidget.imageBox.size;
                          return GestureDetector(
                            onTap: () {
                              if (!block.jigsawBlockWidget.imageBox.isDone) {
                                setState(() {
                                  _index = index;
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.px),
                              padding: EdgeInsets.all(4.px),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.px),
                                color: _index == index
                                    ? themeState.settingCustomContainerColor!
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _index == index
                                      ? themeState
                                            .settingCustomContainerBorderColor!
                                      : Colors.transparent,
                                  width: 1.px,
                                ),
                                boxShadow: [
                                  if (_index == index)
                                    BoxShadow(
                                      color: themeState
                                          .settingCustomContainerShadowColor!
                                          .withOpacityValue(0.2),
                                      blurRadius: 10,
                                      offset: Offset(0, 10),
                                    ),
                                ],
                              ),
                              child: FittedBox(
                                child: SizedBox(
                                  width: sizeBlock.width,
                                  height: sizeBlock.height,
                                  child: block.jigsawBlockWidget,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
