import '../../domain/entities/goal_entity.dart';

abstract class GoalState {}
class GoalInitial extends GoalState {}
class GoalLoading extends GoalState {}
class GoalLoaded extends GoalState {
  final List<GoalEntity> goals;
  GoalLoaded(this.goals);
}
class GoalError extends GoalState {
  final String message;
  GoalError(this.message);
}