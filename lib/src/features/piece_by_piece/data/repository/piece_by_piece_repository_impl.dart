import '../../domain/repository/piece_by_piece_repository.dart';
import '../datasource/piece_by_piece_datasource.dart';

class PieceByPieceRepositoryImpl implements PieceByPieceRepository {
  final ApiPieceByPieceDataSource _dataSource;

  PieceByPieceRepositoryImpl({
    required ApiPieceByPieceDataSource dataSource,
  }) : _dataSource = dataSource;
}
