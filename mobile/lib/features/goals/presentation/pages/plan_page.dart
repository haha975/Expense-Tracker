import 'package:flutter/material.dart';


import '../widgets/plan_toggle_switch.dart';
import 'budgets_view.dart';
import 'savings_goals_view.dart';
import 'package:go_router/go_router.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  PlanTab _selectedTab = PlanTab.savingsGoals; // Default active tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar & Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add,
                              color: Colors.white, size: 20),
                          onPressed: () {
  if (_selectedTab == PlanTab.budgets) {
    context.push('/budget-detail');
  } else {
    // Keep the existing Savings Goals behavior here.
  }
},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Functional Interactive Switch
                  PlanToggleSwitch(
                    activeTab: _selectedTab,
                    onTabChanged: (newTab) {
                      setState(() {
                        _selectedTab = newTab;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dynamic Content Area
            Expanded(
              child: IndexedStack(
                index: _selectedTab == PlanTab.budgets ? 0 : 1,
                children: const [
                  BudgetsView(),
                  SavingsGoalsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}