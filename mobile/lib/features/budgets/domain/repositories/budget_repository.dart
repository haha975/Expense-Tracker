// Optional or use standard Future
import '../entities/budget_detail.dart';

abstract class BudgetRepository {
  Future<BudgetDetail> getBudgetDetail(String budgetId);
}