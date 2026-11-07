import '../../domain/entities/statistics_entity.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_local_data_source.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsLocalDataSource localDataSource;

  StatisticsRepositoryImpl(this.localDataSource);

  @override
  Future<StatisticsEntity> getStatistics(String period) async {
    return await localDataSource.getCachedStatistics(period);
  }
}