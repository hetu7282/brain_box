import '../../domain/repository/kings_gambit_repository.dart';
import '../datasource/kings_gambit_datasource.dart';

class KingsGambitRepositoryImpl implements KingsGambitRepository {
  final ApiKingsGambitDataSource _dataSource;

  KingsGambitRepositoryImpl({
    required ApiKingsGambitDataSource dataSource,
  }) : _dataSource = dataSource;
}
