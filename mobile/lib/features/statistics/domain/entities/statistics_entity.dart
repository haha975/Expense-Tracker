class ExpenseCategory {
  final String name;
  final double amount;
  final double percentage;
  final String colorHex;

  const ExpenseCategory({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.colorHex,
  });
}

class StatisticsEntity {
  final String period; // Week, Month, Year
  final String dateRangeLabel; // "October 2026"
  final String subDateLabel; // "Oct 1 – 8 • Month to date"
  final double totalExpenses;
  final double dailyAverage;
  final double totalIncome;
  final double netCashFlow;
  final double incomeSpentPercentage;
  final double incomeRetainedPercentage;
  final List<ExpenseCategory> categories;

  const StatisticsEntity({
    required this.period,
    required this.dateRangeLabel,
    required this.subDateLabel,
    required this.totalExpenses,
    required this.dailyAverage,
    required this.totalIncome,
    required this.netCashFlow,
    required this.incomeSpentPercentage,
    required this.incomeRetainedPercentage,
    required this.categories,
  });
}