import '../../domain/entities/budget_category_entity.dart';

abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<BudgetCategoryEntity> categories;

  BudgetLoaded(this.categories);
}

class BudgetError extends BudgetState {
  final String message;

  BudgetError(this.message);
}