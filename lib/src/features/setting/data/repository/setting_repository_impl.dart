import '../../domain/repository/setting_repository.dart';
import '../datasource/setting_datasource.dart';

class SettingRepositoryImpl implements SettingRepository {
  final ApiSettingDataSource _dataSource;

  SettingRepositoryImpl({
    required ApiSettingDataSource dataSource,
  }) : _dataSource = dataSource;
}
