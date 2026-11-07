
import '../models/statistics_model.dart';

abstract class StatisticsLocalDataSource {
  Future<StatisticsModel> getCachedStatistics(String period);
}

class StatisticsLocalDataSourceImpl implements StatisticsLocalDataSource {
  @override
  Future<StatisticsModel> getCachedStatistics(String period) async {
    switch (period) {
      case 'Week':
        return const StatisticsModel(
          period: 'Week',
          dateRangeLabel: 'Oct 12 – 18, 2026',
          subDateLabel: 'Last 7 days',
          totalExpenses: 425.80,
          dailyAverage: 60.83,
          totalIncome: 1200.00,
          netCashFlow: 774.20,
          incomeSpentPercentage: 35.5,
          incomeRetainedPercentage: 64.5,
          categories: [
            ExpenseCategoryModel(
              name: 'Housing',
              amount: 200.00,
              percentage: 47.0,
              colorHex: '#8B5CF6',
            ),
            ExpenseCategoryModel(
              name: 'Food & dining',
              amount: 105.80,
              percentage: 24.8,
              colorHex: '#A78BFA',
            ),
            ExpenseCategoryModel(
              name: 'Shopping',
              amount: 65.00,
              percentage: 15.3,
              colorHex: '#C4B5FD',
            ),
            ExpenseCategoryModel(
              name: 'Transport',
              amount: 55.00,
              percentage: 12.9,
              colorHex: '#DDD6FE',
            ),
          ],
        );

      case 'Year':
        return const StatisticsModel(
          period: 'Year',
          dateRangeLabel: 'January – December 2026',
          subDateLabel: 'Year to date',
          totalExpenses: 14500.00,
          dailyAverage: 39.73,
          totalIncome: 36000.00,
          netCashFlow: 21500.00,
          incomeSpentPercentage: 40.3,
          incomeRetainedPercentage: 59.7,
          categories: [
            ExpenseCategoryModel(
              name: 'Housing',
              amount: 7800.00,
              percentage: 53.8,
              colorHex: '#8B5CF6',
            ),
            ExpenseCategoryModel(
              name: 'Food & dining',
              amount: 2800.00,
              percentage: 19.3,
              colorHex: '#A78BFA',
            ),
            ExpenseCategoryModel(
              name: 'Shopping',
              amount: 2100.00,
              percentage: 14.5,
              colorHex: '#C4B5FD',
            ),
            ExpenseCategoryModel(
              name: 'Transport',
              amount: 1100.00,
              percentage: 7.6,
              colorHex: '#DDD6FE',
            ),
            ExpenseCategoryModel(
              name: 'Subscriptions',
              amount: 700.00,
              percentage: 4.8,
              colorHex: '#EDE9FE',
            ),
          ],
        );

      case 'Month':
      default:
        return const StatisticsModel(
          period: 'Month',
          dateRangeLabel: 'October 2026',
          subDateLabel: 'October monthly overview',
          totalExpenses: 1842.50,
          dailyAverage: 230.31,
          totalIncome: 5200.00,
          netCashFlow: 3357.50,
          incomeSpentPercentage: 35.4,
          incomeRetainedPercentage: 64.6,
          categories: [
            ExpenseCategoryModel(
              name: 'Housing',
              amount: 1200.00,
              percentage: 65.1,
              colorHex: '#8B5CF6',
            ),
            ExpenseCategoryModel(
              name: 'Food & dining',
              amount: 285.50,
              percentage: 15.5,
              colorHex: '#A78BFA',
            ),
            ExpenseCategoryModel(
              name: 'Shopping',
              amount: 160.00,
              percentage: 8.7,
              colorHex: '#C4B5FD',
            ),
            ExpenseCategoryModel(
              name: 'Transport',
              amount: 112.00,
              percentage: 6.1,
              colorHex: '#DDD6FE',
            ),
            ExpenseCategoryModel(
              name: 'Subscriptions',
              amount: 85.00,
              percentage: 4.6,
              colorHex: '#EDE9FE',
            ),
          ],
        );
    }
  }
}
