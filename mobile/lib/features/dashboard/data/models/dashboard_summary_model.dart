import '../../domain/entities/dashboard_summary.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required String id,
    required String title,
    required String category,
    required String dateText,
    required double amount,
    required TransactionType type,
  }) : super(
          id: id,
          title: title,
          category: category,
          dateText: dateText,
          amount: amount,
          type: type,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      dateText: json['dateText'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'income' ? TransactionType.income : TransactionType.expense,
    );
  }
}

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required double availableBalance,
    required double netThisMonth,
    required double totalIncome,
    required double totalExpense,
    required double budgetSpent,
    required double budgetTotal,
    required List<TransactionModel> recentTransactions,
  }) : super(
          availableBalance: availableBalance,
          netThisMonth: netThisMonth,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          budgetSpent: budgetSpent,
          budgetTotal: budgetTotal,
          recentTransactions: recentTransactions,
        );

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      availableBalance: (json['availableBalance'] as num).toDouble(),
      netThisMonth: (json['netThisMonth'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      budgetSpent: (json['budgetSpent'] as num).toDouble(),
      budgetTotal: (json['budgetTotal'] as num).toDouble(),
      recentTransactions: (json['recentTransactions'] as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList(),
    );
  }
}