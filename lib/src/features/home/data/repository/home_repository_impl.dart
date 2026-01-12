import '../../domain/repository/home_repository.dart';
import '../datasource/home_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiHomeDataSource _dataSource;

  HomeRepositoryImpl({
    required ApiHomeDataSource dataSource,
  }) : _dataSource = dataSource;
}
