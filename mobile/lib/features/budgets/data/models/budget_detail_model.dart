import '../../domain/entities/budget_detail.dart';

class ExpenseItemModel extends ExpenseItem {
  const ExpenseItemModel({
    required super.id,
    required super.title,
    required super.category,
    required super.date,
    required super.amount,
    required super.iconType,
  });

  factory ExpenseItemModel.fromJson(Map<String, dynamic> json) {
    return ExpenseItemModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      date: json['date'],
      amount: json['amount'],
      iconType: json['iconType'],
    );
  }
}

class BudgetDetailModel extends BudgetDetail {
  const BudgetDetailModel({
    required super.categoryName,
    required super.budgetPeriod,
    required super.spentAmount,
    required super.totalLimit,
    required super.leftAmountText,
    required super.usagePercentage,
    required super.alertInfo,
    required super.alertEnabled,
    required super.dailySpending,
    required super.recentExpenses,
  });

  factory BudgetDetailModel.fromJson(Map<String, dynamic> json) {
    return BudgetDetailModel(
      categoryName: json['categoryName'],
      budgetPeriod: json['budgetPeriod'],
      spentAmount: json['spentAmount'],
      totalLimit: json['totalLimit'],
      leftAmountText: json['leftAmountText'],
      usagePercentage: json['usagePercentage'],
      alertInfo: json['alertInfo'],
      alertEnabled: json['alertEnabled'],
      dailySpending: List<double>.from(json['dailySpending']),
      recentExpenses: (json['recentExpenses'] as List)
          .map((e) => ExpenseItemModel.fromJson(e))
          .toList(),
    );
  }
}