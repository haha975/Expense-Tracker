 // Optional or use standard exceptions
import '../entities/goal_entity.dart';

abstract class GoalRepository {
  Future<List<GoalEntity>> getSavingsGoals();
}