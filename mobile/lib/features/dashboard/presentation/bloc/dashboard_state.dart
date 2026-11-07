import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_summary.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardSummary summary;
  final bool isBalanceVisible;

  const DashboardLoaded({
    required this.summary,
    this.isBalanceVisible = true,
  });

  DashboardLoaded copyWith({
    DashboardSummary? summary,
    bool? isBalanceVisible,
  }) {
    return DashboardLoaded(
      summary: summary ?? this.summary,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
    );
  }

  @override
  List<Object?> get props => [summary, isBalanceVisible];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}