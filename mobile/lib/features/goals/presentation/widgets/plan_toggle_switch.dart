import 'package:flutter/material.dart';

enum PlanTab { budgets, savingsGoals }

class PlanToggleSwitch extends StatelessWidget {
  final PlanTab activeTab;
  final ValueChanged<PlanTab> onTabChanged;

  const PlanToggleSwitch({
    Key? key,
    required this.activeTab,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          // Budgets Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(PlanTab.budgets),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: activeTab == PlanTab.budgets
                      ? const Color(0xFF23232D)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Budgets',
                  style: TextStyle(
                    color: activeTab == PlanTab.budgets
                        ? Colors.white
                        : Colors.grey[500],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          // Savings Goals Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(PlanTab.savingsGoals),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: activeTab == PlanTab.savingsGoals
                      ? const Color(0xFF23232D)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Savings goals',
                  style: TextStyle(
                    color: activeTab == PlanTab.savingsGoals
                        ? Colors.white
                        : Colors.grey[500],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}