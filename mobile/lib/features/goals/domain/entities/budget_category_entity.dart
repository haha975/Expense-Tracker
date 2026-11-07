
class BudgetCategoryEntity {
  final String id;
  final String categoryName;
  final String iconName;
  final double spentAmount;
  final double budgetLimit;

  const BudgetCategoryEntity({
    required this.id,
    required this.categoryName,
    required this.iconName,
    required this.spentAmount,
    required this.budgetLimit,
  });

  double get progressPercentage {
    if (budgetLimit <= 0) return 0;
    return (spentAmount / budgetLimit).clamp(0.0, 1.0);
  }

  double get remainingAmount => budgetLimit - spentAmount;

  bool get isLimitReached => spentAmount >= budgetLimit;

  String? get statusMessage {
    if (budgetLimit <= 0) return 'Set a budget limit';
    if (spentAmount > budgetLimit) {
      return '\$${(spentAmount - budgetLimit).toStringAsFixed(2)} over budget';
    }
    if (spentAmount >= budgetLimit * 0.8) {
      return 'You are close to your budget limit';
    }
    return null;
  }
}
