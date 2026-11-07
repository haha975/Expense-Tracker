
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/goal_bloc.dart';
import '../bloc/goal_state.dart';
import '../widgets/goal_card.dart';
import '../widgets/savings_summary_card.dart';

class SavingsGoalsView extends StatelessWidget {
  const SavingsGoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalBloc, GoalState>(
      builder: (context, state) {
        if (state is GoalLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF8B5CF6),
            ),
          );
        }

        if (state is GoalLoaded) {
          final goals = state.goals;
          final totalSaved = goals.fold<double>(
            0,
            (sum, goal) => sum + goal.currentAmount,
          );
          final totalTarget = goals.fold<double>(
            0,
            (sum, goal) => sum + goal.targetAmount,
          );

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            children: [
              SavingsSummaryCard(
                totalSaved: totalSaved,
                totalTarget: totalTarget,
                activeGoalsCount: goals.length,
              ),
              const SizedBox(height: 20),
              const Text(
                'A little closer, every month',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...goals.map((goal) => GoalCard(goal: goal)),
            ],
          );
        }

        if (state is GoalError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
