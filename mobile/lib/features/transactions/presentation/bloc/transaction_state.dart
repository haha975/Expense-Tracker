
import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  final String searchQuery;
  final int selectedFilterIndex;
  final int pendingSyncCount;

  final String categoryFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;

  const TransactionLoaded({
    required this.transactions,
    this.searchQuery = '',
    this.selectedFilterIndex = 0,
    required this.pendingSyncCount,
    this.categoryFilter = '',
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
  });

  TransactionLoaded copyWith({
    List<TransactionEntity>? transactions,
    String? searchQuery,
    int? selectedFilterIndex,
    int? pendingSyncCount,
    String? categoryFilter,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    bool clearDateRange = false,
    bool clearAmountRange = false,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilterIndex:
          selectedFilterIndex ?? this.selectedFilterIndex,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      startDate: clearDateRange ? null : startDate ?? this.startDate,
      endDate: clearDateRange ? null : endDate ?? this.endDate,
      minAmount: clearAmountRange ? null : minAmount ?? this.minAmount,
      maxAmount: clearAmountRange ? null : maxAmount ?? this.maxAmount,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        searchQuery,
        selectedFilterIndex,
        pendingSyncCount,
        categoryFilter,
        startDate,
        endDate,
        minAmount,
        maxAmount,
      ];
}
