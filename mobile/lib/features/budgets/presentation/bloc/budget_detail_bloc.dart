import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/budget_detail.dart';
import '../../domain/usecases/get_budget_detail.dart';

// Events
abstract class BudgetDetailEvent {}
class LoadBudgetDetail extends BudgetDetailEvent {
  final String budgetId;
  LoadBudgetDetail(this.budgetId);
}

// States
abstract class BudgetDetailState {}
class BudgetDetailInitial extends BudgetDetailState {}
class BudgetDetailLoading extends BudgetDetailState {}
class BudgetDetailLoaded extends BudgetDetailState {
  final BudgetDetail budgetDetail;
  BudgetDetailLoaded(this.budgetDetail);
}
class BudgetDetailError extends BudgetDetailState {
  final String message;
  BudgetDetailError(this.message);
}

// BLoC
class BudgetDetailBloc extends Bloc<BudgetDetailEvent, BudgetDetailState> {
  final GetBudgetDetail getBudgetDetail;

  BudgetDetailBloc({required this.getBudgetDetail}) : super(BudgetDetailInitial()) {
    on<LoadBudgetDetail>((event, emit) async {
      emit(BudgetDetailLoading());
      try {
        final detail = await getBudgetDetail(event.budgetId);
        emit(BudgetDetailLoaded(detail));
      } catch (e) {
        emit(BudgetDetailError(e.toString()));
      }
    });
  }
}