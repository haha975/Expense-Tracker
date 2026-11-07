import '../models/dashboard_summary_model.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardSummaryModel> getDashboardSummary();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    // Simulated network/local storage response matching image data
    await Future.delayed(const Duration(milliseconds: 500));
    return DashboardSummaryModel.fromJson({
      'availableBalance': 6457.50,
      'netThisMonth': 3357.50,
      'totalIncome': 5200.00,
      'totalExpense': 1842.50,
      'budgetSpent': 1842.50,
      'budgetTotal': 2500.00,
      'recentTransactions': [
        {
          'id': '1',
          'title': 'Whole Foods Market',
          'category': 'Food & dining',
          'dateText': 'Today',
          'amount': -84.50,
          'type': 'expense'
        },
        {
          'id': '2',
          'title': 'Blue Bottle Coffee',
          'category': 'Food & dining',
          'dateText': 'Today',
          'amount': -6.00,
          'type': 'expense'
        },
        {
          'id': '3',
          'title': 'October salary',
          'category': 'Income',
          'dateText': 'Oct 5',
          'amount': 5200.00,
          'type': 'income'
        },
      ],
    });
  }
}