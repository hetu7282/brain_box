import '../../domain/repository/onboarding_repository.dart';
import '../datasource/onboarding_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final ApiOnboardingDataSource _dataSource;

  OnboardingRepositoryImpl({
    required ApiOnboardingDataSource dataSource,
  }) : _dataSource = dataSource;
}
