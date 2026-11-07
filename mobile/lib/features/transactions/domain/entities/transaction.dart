enum TransactionType {
  income,
  expense,
}

enum SyncStatus {
  synced,
  pending,
}

class TransactionEntity {
  final String id;
  final String title;
  final String category;
  final String time;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final SyncStatus syncStatus;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.date,
    required this.type,
    this.syncStatus = SyncStatus.synced,
  });
}
