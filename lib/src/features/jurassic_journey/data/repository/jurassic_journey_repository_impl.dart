import '../../domain/repository/jurassic_journey_repository.dart';
import '../datasource/jurassic_journey_datasource.dart';

class JurassicJourneyRepositoryImpl implements JurassicJourneyRepository {
  final ApiJurassicJourneyDataSource _dataSource;

  JurassicJourneyRepositoryImpl({
    required ApiJurassicJourneyDataSource dataSource,
  }) : _dataSource = dataSource;
}
