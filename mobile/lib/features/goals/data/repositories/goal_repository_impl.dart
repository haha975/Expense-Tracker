import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/goal_local_data_source.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalLocalDataSource localDataSource;

  GoalRepositoryImpl({required this.localDataSource});

  @override
  Future<List<GoalEntity>> getSavingsGoals() async {
    final goalModels = await localDataSource.getSavingsGoals();
    return goalModels;
  }
}