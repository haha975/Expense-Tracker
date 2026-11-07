import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class TransactionEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String dateText;
  final double amount;
  final TransactionType type;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.dateText,
    required this.amount,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, category, dateText, amount, type];
}

class DashboardSummary extends Equatable {
  final double availableBalance;
  final double netThisMonth;
  final double totalIncome;
  final double totalExpense;
  final double budgetSpent;
  final double budgetTotal;
  final List<TransactionEntity> recentTransactions;

  const DashboardSummary({
    required this.availableBalance,
    required this.netThisMonth,
    required this.totalIncome,
    required this.totalExpense,
    required this.budgetSpent,
    required this.budgetTotal,
    required this.recentTransactions,
  });

  double get budgetLeft => budgetTotal - budgetSpent;
  double get budgetProgress => (budgetTotal == 0) ? 0.0 : (budgetSpent / budgetTotal);

  @override
  List<Object?> get props => [
        availableBalance,
        netThisMonth,
        totalIncome,
        totalExpense,
        budgetSpent,
        budgetTotal,
        recentTransactions,
      ];
}