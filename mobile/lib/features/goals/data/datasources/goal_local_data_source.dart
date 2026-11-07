import '../models/goal_model.dart';

abstract class GoalLocalDataSource {
  Future<List<GoalModel>> getSavingsGoals();
}

class GoalLocalDataSourceImpl implements GoalLocalDataSource {
  @override
  Future<List<GoalModel>> getSavingsGoals() async {
    // Simulated mock database / API response matching your screenshot
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      GoalModel(
        id: '1',
        title: 'Emergency fund',
        targetDate: 'Mar 2027',
        currentAmount: 4200.0,
        targetAmount: 5000.0,
        monthlyPlanned: 306.0,
        iconName: 'shield',
      ),
      GoalModel(
        id: '2',
        title: 'Japan trip',
        targetDate: 'Apr 2027',
        currentAmount: 900.0,
        targetAmount: 2000.0,
        monthlyPlanned: 166.0,
        iconName: 'flight',
      ),
      GoalModel(
        id: '3',
        title: 'New laptop',
        targetDate: 'Feb 2027',
        currentAmount: 500.0,
        targetAmount: 1500.0,
        monthlyPlanned: 208.0,
        iconName: 'laptop',
      ),
    ];
  }
}