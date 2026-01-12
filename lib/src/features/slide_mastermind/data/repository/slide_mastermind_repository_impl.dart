import '../../domain/repository/slide_mastermind_repository.dart';
import '../datasource/slide_mastermind_datasource.dart';

class SlideMastermindRepositoryImpl implements SlideMastermindRepository {
  final ApiSlideMastermindDataSource _dataSource;

  SlideMastermindRepositoryImpl({
    required ApiSlideMastermindDataSource dataSource,
  }) : _dataSource = dataSource;
}
