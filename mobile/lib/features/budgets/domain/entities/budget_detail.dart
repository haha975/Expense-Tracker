class ExpenseItem {
  final String id;
  final String title;
  final String category;
  final String date;
  final double amount;
  final String iconType;

  const ExpenseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.iconType,
  });
}

class BudgetDetail {
  final String categoryName;
  final String budgetPeriod;
  final double spentAmount;
  final double totalLimit;
  final String leftAmountText;
  final double usagePercentage;
  final String alertInfo;
  final bool alertEnabled;
  final List<double> dailySpending;
  final List<ExpenseItem> recentExpenses;

  const BudgetDetail({
    required this.categoryName,
    required this.budgetPeriod,
    required this.spentAmount,
    required this.totalLimit,
    required this.leftAmountText,
    required this.usagePercentage,
    required this.alertInfo,
    required this.alertEnabled,
    required this.dailySpending,
    required this.recentExpenses,
  });
}