import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/goal_bloc.dart';

import '../bloc/goal_state.dart';
import '../widgets/goal_card.dart';
import '../widgets/savings_summary_card.dart';

class SavingsGoalsPage extends StatelessWidget {
  const SavingsGoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      body: SafeArea(
        child: BlocBuilder<GoalBloc, GoalState>(
          builder: (context, state) {
            if (state is GoalLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
              );
            } else if (state is GoalLoaded) {
              final goals = state.goals;
              double totalSaved = goals.fold(0, (sum, item) => sum + item.currentAmount);
              double totalTarget = goals.fold(0, (sum, item) => sum + item.targetAmount);

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXPENSE TRACKER',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Your plan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E24),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white, size: 20),
                            onPressed: () {
                              // Add goal action
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Segmented Tabs (Budgets vs Savings Goals)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16161A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Switch to budgets view
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                alignment: Alignment.center,
                                child: Text(
                                  'Budgets',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF23232D),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Savings goals',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Summary Card
                    SavingsSummaryCard(
                      totalSaved: totalSaved,
                      totalTarget: totalTarget,
                      activeGoalsCount: goals.length,
                    ),
                    const SizedBox(height: 28),

                    // Section Title
                    const Text(
                      'A little closer, every month',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Goals List
                    ...goals.map((goal) => GoalCard(goal: goal)).toList(),

                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Monthly plans are targets, not automatic transfers.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            } else if (state is GoalError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}