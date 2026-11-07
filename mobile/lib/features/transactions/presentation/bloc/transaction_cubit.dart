
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepositoryImpl _repository;
  List<TransactionEntity> _allTransactions = [];

  TransactionCubit(this._repository) : super(TransactionInitial()) {
    loadTransactions();
  }

  void loadTransactions() {
    _allTransactions = _repository.getTransactions();

    emit(
      TransactionLoaded(
        transactions: _allTransactions,
        pendingSyncCount: _pendingSyncCount,
      ),
    );
  }

  int get _pendingSyncCount => _allTransactions
      .where((tx) => tx.syncStatus == SyncStatus.pending)
      .length;

  void addTransaction(TransactionEntity transaction) {
    _repository.addTransaction(transaction);
    _allTransactions = _repository.getTransactions();

    final currentState = state;

    if (currentState is TransactionLoaded) {
      emit(
        currentState.copyWith(
          transactions: _allTransactions,
          pendingSyncCount: _pendingSyncCount,
        ),
      );
    } else {
      loadTransactions();
    }
  }

  void setSearchQuery(String query) {
    final currentState = state;
    if (currentState is TransactionLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  void setFilterIndex(int index) {
    final currentState = state;
    if (currentState is TransactionLoaded) {
      emit(currentState.copyWith(selectedFilterIndex: index));
    }
  }

  void setAdvancedFilters({
    required String category,
    required DateTime? startDate,
    required DateTime? endDate,
    required double? minAmount,
    required double? maxAmount,
  }) {
    final currentState = state;
    if (currentState is! TransactionLoaded) return;

    emit(
      currentState.copyWith(
        categoryFilter: category,
        startDate: startDate,
        endDate: endDate,
        minAmount: minAmount,
        maxAmount: maxAmount,
        clearDateRange: startDate == null && endDate == null,
        clearAmountRange: minAmount == null && maxAmount == null,
      ),
    );
  }

  void resetAllFilters() {
    final currentState = state;
    if (currentState is! TransactionLoaded) return;

    emit(
      TransactionLoaded(
        transactions: _allTransactions,
        pendingSyncCount: _pendingSyncCount,
      ),
    );
  }

  List<TransactionEntity> getFilteredTransactions(
    TransactionLoaded currentState,
  ) {
    final query = currentState.searchQuery.trim().toLowerCase();

    final results = _allTransactions.where((tx) {
      final matchesSearch = tx.title.toLowerCase().contains(query) ||
          tx.category.toLowerCase().contains(query);

      var matchesType = true;
      if (currentState.selectedFilterIndex == 1) {
        matchesType = tx.type == TransactionType.expense;
      } else if (currentState.selectedFilterIndex == 2) {
        matchesType = tx.type == TransactionType.income;
      }

      final matchesCategory = currentState.categoryFilter.isEmpty ||
          tx.category == currentState.categoryFilter;

      final date = DateTime(tx.date.year, tx.date.month, tx.date.day);

      final matchesStartDate = currentState.startDate == null ||
          !date.isBefore(
            DateTime(
              currentState.startDate!.year,
              currentState.startDate!.month,
              currentState.startDate!.day,
            ),
          );

      final matchesEndDate = currentState.endDate == null ||
          !date.isAfter(
            DateTime(
              currentState.endDate!.year,
              currentState.endDate!.month,
              currentState.endDate!.day,
            ),
          );

      final amount = tx.amount.abs();

      final matchesMinAmount = currentState.minAmount == null ||
          amount >= currentState.minAmount!;

      final matchesMaxAmount = currentState.maxAmount == null ||
          amount <= currentState.maxAmount!;

      return matchesSearch &&
          matchesType &&
          matchesCategory &&
          matchesStartDate &&
          matchesEndDate &&
          matchesMinAmount &&
          matchesMaxAmount;
    }).toList();

    results.sort((a, b) => b.date.compareTo(a.date));
    return results;
  }
}
