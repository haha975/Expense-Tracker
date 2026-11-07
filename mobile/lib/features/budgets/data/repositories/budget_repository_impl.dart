import '../../domain/entities/budget_detail.dart';
import '../../domain/repositories/budget_repository.dart';
import '../models/budget_detail_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  @override
  Future<BudgetDetail> getBudgetDetail(String budgetId) async {
    // Simulating network or local data fetch matching the exact UI design
    await Future.delayed(const Duration(milliseconds: 300));
    
    return BudgetDetailModel(
      categoryName: "Food & dining",
      budgetPeriod: "OCTOBER BUDGET",
      spentAmount: 285.50,
      totalLimit: 450.00,
      leftAmountText: "\$164.50 left",
      usagePercentage: 0.634,
      alertInfo: "Alert at 80% • Resets November 1",
      alertEnabled: true,
      dailySpending: [10.0, 120.0, 180.0, 15.0, 15.0, 15.0, 45.0, 240.0],
      recentExpenses: [
        ExpenseItemModel(
          id: '1',
          title: 'Whole Foods Market',
          category: 'Groceries',
          date: 'Oct 8',
          amount: -84.50,
          iconType: 'cart',
        ),
        ExpenseItemModel(
          id: '2',
          title: 'Blue Bottle Coffee',
          category: 'Coffee',
          date: 'Oct 8',
          amount: -6.00,
          iconType: 'coffee',
        ),
        ExpenseItemModel(
          id: '3',
          title: 'Sweetgreen',
          category: 'Lunch',
          date: 'Oct 7',
          amount: -24.00,
          iconType: 'restaurant',
        ),
      ],
    );
  }
}