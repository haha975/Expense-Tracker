import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/theme/app_colors.dart';

import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';
import '../bloc/dashboard_event.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/recent_transactions_section.dart';
import '../widgets/dashboard_bottom_nav.dart';

import '../../../transactions/data/repositories/transaction_repository_impl.dart';
import '../../../transactions/presentation/bloc/transaction_cubit.dart';
import '../../../transactions/presentation/pages/transactions_screen.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';

import '../../../statistics/data/datasources/statistics_local_data_source.dart';
import '../../../statistics/data/repositories/statistics_repository_impl.dart';
import '../../../statistics/domain/usecases/get_statistics_usecase.dart';
import '../../../statistics/presentation/bloc/statistics_cubit.dart';
import '../../../statistics/presentation/pages/statistics_page.dart';



import '../../../goals/data/datasources/goal_local_data_source.dart';
import '../../../goals/data/repositories/goal_repository_impl.dart';
import '../../../goals/domain/usecases/get_goals_usecase.dart';
import '../../../goals/presentation/bloc/goal_bloc.dart';
import '../../../goals/data/datasources/budget_local_data_source.dart';
import '../../../goals/data/repositories/budget_repository_impl.dart';
import '../../../goals/domain/usecases/get_budget_categories_usecase.dart';
import '../../../goals/presentation/bloc/budget_bloc.dart';

import '../../../goals/presentation/pages/plan_page.dart';
import '../../../settings/data/repositories/setting_repository_impl.dart';
import '../../../settings/domain/usecases/get_user_settings.dart';
import '../../../settings/domain/usecases/update_setting.dart';
import '../../../settings/presentation/bloc/setting_cubit.dart';
import '../../../settings/presentation/pages/setting_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  StatisticsCubit _createStatisticsCubit() {
  final dataSource = StatisticsLocalDataSourceImpl();
  final repository = StatisticsRepositoryImpl(dataSource);
  final useCase = GetStatisticsUseCase(repository);

  return StatisticsCubit(useCase);
}
  final ValueNotifier<int> _navIndexNotifier = ValueNotifier<int>(0);
  
  @override
  void dispose() {
    _navIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionCubit>(
      create: (_) => TransactionCubit(TransactionRepositoryImpl()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ValueListenableBuilder<int>(
            valueListenable: _navIndexNotifier,
            builder: (context, currentIndex, _) {
              // Activity tab.
              
if (currentIndex == 1) {
  return const TransactionsScreen();
}

// Statistics tab.
if (currentIndex == 2) {
  return BlocProvider<StatisticsCubit>(
    create: (_) => _createStatisticsCubit(),
    child: const StatisticsPage(),
  );
}

// Temporary pages for Plan and Settings.
              
              // Plan tab.
              if (currentIndex == 3) {
                final goalDataSource = GoalLocalDataSourceImpl();
                final goalRepository = GoalRepositoryImpl(
                  localDataSource: goalDataSource,
                );
                final getGoalsUseCase = GetGoalsUseCase(
                  goalRepository,
                );

                final budgetDataSource = BudgetLocalDataSourceImpl();
                final budgetRepository = BudgetRepositoryImpl(
                  localDataSource: budgetDataSource,
                );
                final getBudgetCategoriesUseCase =
                    GetBudgetCategoriesUseCase(budgetRepository);

                return MultiBlocProvider(
                  providers: [
                    BlocProvider<GoalBloc>(
                      create: (_) => GoalBloc(
                        getGoalsUseCase: getGoalsUseCase,
                      ),
                    ),
                    BlocProvider<BudgetBloc>(
                      create: (_) => BudgetBloc(
                        getBudgetCategoriesUseCase:
                            getBudgetCategoriesUseCase,
                      ),
                    ),
                  ],
                  child: const PlanPage(),
                );
              }


              // Settings tab.
if (currentIndex == 4) {
  final repository = SettingRepositoryImpl();

  return BlocProvider<SettingCubit>(
    create: (_) => SettingCubit(
      getUserSettings: GetUserSettings(repository),
      updateSetting: UpdateSetting(repository),
    )..loadSettings(),
    child: const SettingPage(),
  );
}

              // Overview dashboard.
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, state) {
                          if (state is DashboardLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryPurple,
                              ),
                            );
                          }

                          if (state is DashboardLoaded) {
                            final summary = state.summary;

                            return ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              children: [
                                _buildHeader(context),
                                const SizedBox(height: 16),
                                const DashboardQuickActions(),
                                const SizedBox(height: 16),
                                BalanceSummaryCard(
                                  balance: summary.availableBalance,
                                  netMonth: summary.netThisMonth,
                                  income: summary.totalIncome,
                                  expense: summary.totalExpense,
                                  isVisible: state.isBalanceVisible,
                                  onToggleVisibility: () {
                                    context.read<DashboardBloc>().add(
                                          ToggleBalanceVisibilityEvent(),
                                        );
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildBudgetCard(summary),
                                const SizedBox(height: 24),
                                RecentTransactionsSection(
                                  transactions: summary.recentTransactions,
                                ),
                              ],
                            );
                          }

                          if (state is DashboardError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _navIndexNotifier,
          builder: (context, currentIndex, _) {
            return DashboardBottomNav(
              currentIndex: currentIndex,
              onTap: (index) {
                _navIndexNotifier.value = index;
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EXPENSE TRACKER / OCT 8',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.add,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddTransactionPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetCard(dynamic summary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'October budget',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${summary.budgetLeft.toStringAsFixed(2)} left',
                style: const TextStyle(
                  color: AppColors.accentPurpleLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: summary.budgetProgress,
              backgroundColor: AppColors.subCardBg,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryPurple,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${summary.budgetSpent.toStringAsFixed(2)} spent of '
            '\$${summary.budgetTotal.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
