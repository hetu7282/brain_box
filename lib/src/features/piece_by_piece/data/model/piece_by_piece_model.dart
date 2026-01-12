import 'package:brain_box/src/features/piece_by_piece/domain/entity/piece_by_piece_entity.dart';

class PieceByPieceModel extends PieceByPieceEntity {
  const PieceByPieceModel({super.categorie, super.name, super.path});

  factory PieceByPieceModel.fromJson(Map<String, dynamic> json) {
    return PieceByPieceModel(
      categorie: json['category'],
      name: json['name'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'category': categorie, 'name': name, 'path': path};
  }
}
