import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_block_widget.dart';
import 'package:flutter/material.dart';

class BlockClass {
  BlockClass({
    required this.offset,
    required this.jigsawBlockWidget,
    required this.offsetDefault,
  });

  Offset offset;
  Offset offsetDefault;
  JigsawBlockWidget jigsawBlockWidget;
}
