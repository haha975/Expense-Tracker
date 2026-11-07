import '../../domain/entities/goal_entity.dart';

class GoalModel extends GoalEntity {
  const GoalModel({
    required String id,
    required String title,
    required String targetDate,
    required double currentAmount,
    required double targetAmount,
    required double monthlyPlanned,
    required String iconName,
  }) : super(
          id: id,
          title: title,
          targetDate: targetDate,
          currentAmount: currentAmount,
          targetAmount: targetAmount,
          monthlyPlanned: monthlyPlanned,
          iconName: iconName,
        );

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      targetDate: json['targetDate'] as String,
      currentAmount: (json['currentAmount'] as num).toDouble(),
      targetAmount: (json['targetAmount'] as num).toDouble(),
      monthlyPlanned: (json['monthlyPlanned'] as num).toDouble(),
      iconName: json['iconName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetDate': targetDate,
      'currentAmount': currentAmount,
      'targetAmount': targetAmount,
      'monthlyPlanned': monthlyPlanned,
      'iconName': iconName,
    };
  }
}