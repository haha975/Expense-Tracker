import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_summary.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummary getDashboardSummary;

  DashboardBloc({required this.getDashboardSummary}) : super(DashboardInitial()) {
    on<LoadDashboardSummaryEvent>(_onLoadSummary);
    on<ToggleBalanceVisibilityEvent>(_onToggleBalanceVisibility);
  }

  Future<void> _onLoadSummary(
    LoadDashboardSummaryEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final summary = await getDashboardSummary();
      emit(DashboardLoaded(summary: summary));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void _onToggleBalanceVisibility(
    ToggleBalanceVisibilityEvent event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(
        isBalanceVisible: !currentState.isBalanceVisible,
      ));
    }
  }
}