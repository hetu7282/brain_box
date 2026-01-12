import '../../domain/repository/quick_type_quest_repository.dart';
import '../datasource/quick_type_quest_datasource.dart';

class QuickTypeQuestRepositoryImpl implements QuickTypeQuestRepository {
  final ApiQuickTypeQuestDataSource _dataSource;

  QuickTypeQuestRepositoryImpl({
    required ApiQuickTypeQuestDataSource dataSource,
  }) : _dataSource = dataSource;
}
