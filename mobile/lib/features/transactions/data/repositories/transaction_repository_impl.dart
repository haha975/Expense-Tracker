
import '../../domain/entities/transaction.dart';

class TransactionRepositoryImpl {
  final List<TransactionEntity> _transactions = [];

  TransactionRepositoryImpl() {
    final now = DateTime.now();

    _transactions.addAll([
      TransactionEntity(
        id: '1',
        title: 'Whole Foods Market',
        category: 'Food & dining',
        time: '09:32',
        amount: -84.50,
        date: DateTime(now.year, 10, 8),
        type: TransactionType.expense,
        syncStatus: SyncStatus.pending,
      ),
      TransactionEntity(
        id: '2',
        title: 'Blue Bottle Coffee',
        category: 'Food & dining',
        time: '08:15',
        amount: -6.00,
        date: DateTime(now.year, 10, 8),
        type: TransactionType.expense,
        syncStatus: SyncStatus.pending,
      ),
      TransactionEntity(
        id: '3',
        title: 'Sweetgreen',
        category: 'Food & dining',
        time: '13:10',
        amount: -24.00,
        date: DateTime(now.year, 10, 7),
        type: TransactionType.expense,
      ),
      TransactionEntity(
        id: '4',
        title: 'COS',
        category: 'Shopping',
        time: '11:42',
        amount: -160.00,
        date: DateTime(now.year, 10, 7),
        type: TransactionType.expense,
      ),
      TransactionEntity(
        id: '5',
        title: 'Uber',
        category: 'Transport',
        time: '09:20',
        amount: -32.00,
        date: DateTime(now.year, 10, 7),
        type: TransactionType.expense,
      ),
      TransactionEntity(
        id: '6',
        title: 'October salary',
        category: 'Income · Bank transfer',
        time: '10:00',
        amount: 5200.00,
        date: DateTime(now.year, 10, 5),
        type: TransactionType.income,
      ),
    ]);
  }

  List<TransactionEntity> getTransactions() {
    return List.unmodifiable(_transactions);
  }

  void addTransaction(TransactionEntity transaction) {
    _transactions.insert(0, transaction);
  }
}
