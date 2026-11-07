import '../../domain/entities/statistics_entity.dart';

class ExpenseCategoryModel extends ExpenseCategory {
  const ExpenseCategoryModel({
    required super.name,
    required super.amount,
    required super.percentage,
    required super.colorHex,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      name: json['name'],
      amount: json['amount'],
      percentage: json['percentage'],
      colorHex: json['colorHex'],
    );
  }
}

class StatisticsModel extends StatisticsEntity {
  const StatisticsModel({
    required super.period,
    required super.dateRangeLabel,
    required super.subDateLabel,
    required super.totalExpenses,
    required super.dailyAverage,
    required super.totalIncome,
    required super.netCashFlow,
    required super.incomeSpentPercentage,
    required super.incomeRetainedPercentage,
    required super.categories,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      period: json['period'],
      dateRangeLabel: json['dateRangeLabel'],
      subDateLabel: json['subDateLabel'],
      totalExpenses: json['totalExpenses'],
      dailyAverage: json['dailyAverage'],
      totalIncome: json['totalIncome'],
      netCashFlow: json['netCashFlow'],
      incomeSpentPercentage: json['incomeSpentPercentage'],
      incomeRetainedPercentage: json['incomeRetainedPercentage'],
      categories: (json['categories'] as List)
          .map((c) => ExpenseCategoryModel.fromJson(c))
          .toList(),
    );
  }
}