import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/statistics_cubit.dart';
import '../widgets/statistics_header.dart';
import '../widgets/category_breakdown_card.dart';
import '../widgets/cash_flow_card.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedPeriod = 'Month';

  @override
  void initState() {
    super.initState();
    context.read<StatisticsCubit>().fetchStatistics(_selectedPeriod);
  }

  void _onDownloadPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Downloading statistics report...'),
        backgroundColor: const Color(0xFF8B5CF6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121216),
      body: SafeArea(
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
            } else if (state is StatisticsLoaded) {
              final stats = state.statistics;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header & Switchers
                    StatisticsHeader(
                      selectedPeriod: _selectedPeriod,
                      onPeriodChanged: (period) {
                        setState(() => _selectedPeriod = period);
                        context.read<StatisticsCubit>().fetchStatistics(period);
                      },
                      dateRangeLabel: stats.dateRangeLabel,
                      subDateLabel: stats.subDateLabel,
                      onDownloadPressed: () => _onDownloadPressed(context),
                    ),
                    const SizedBox(height: 20),

                    // Total Expenses Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total expenses', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(
                                '\$${stats.totalExpenses.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${stats.dailyAverage.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              Text('daily average', style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category Breakdown & Donut Card
                    CategoryBreakdownCard(
                      categories: stats.categories,
                      spentPercentage: stats.incomeSpentPercentage,
                    ),
                    const SizedBox(height: 16),

                    // Cash Flow Card
                    CashFlowCard(
                      income: stats.totalIncome,
                      expenses: stats.totalExpenses,
                      netCashFlow: stats.netCashFlow,
                    ),
                    const SizedBox(height: 16),

                    // Bottom Insight Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1B2E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF3B2E5C)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "You've retained ${stats.incomeRetainedPercentage}% of your income this month. Keep your goals moving.",
                              style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            } else if (state is StatisticsError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
