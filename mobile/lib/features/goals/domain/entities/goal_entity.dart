class GoalEntity {
  final String id;
  final String title;
  final String targetDate;
  final double currentAmount;
  final double targetAmount;
  final double monthlyPlanned;
  final String iconName;

  const GoalEntity({
    required this.id,
    required this.title,
    required this.targetDate,
    required this.currentAmount,
    required this.targetAmount,
    required this.monthlyPlanned,
    required this.iconName,
  });

  double get progressPercentage => (currentAmount / targetAmount).clamp(0.0, 1.0);
  double get amountToGo => targetAmount - currentAmount;
  int get percentageInt => (progressPercentage * 100).round();
}