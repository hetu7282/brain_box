import 'package:equatable/equatable.dart';

class PieceByPieceEntity extends Equatable {
  final String? categorie;
  final String? name;
  final String? path;
  const PieceByPieceEntity({this.categorie, this.name, this.path});

  @override
  List<Object?> get props => [categorie, name, path];
}
