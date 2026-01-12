import '../../domain/repository/tic_tac_twist_repository.dart';
import '../datasource/tic_tac_twist_datasource.dart';

class TicTacTwistRepositoryImpl implements TicTacTwistRepository {
  final ApiTicTacTwistDataSource _dataSource;

  TicTacTwistRepositoryImpl({
    required ApiTicTacTwistDataSource dataSource,
  }) : _dataSource = dataSource;
}
