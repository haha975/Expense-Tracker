import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_budget_categories_usecase.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgetCategoriesUseCase getBudgetCategoriesUseCase;

  BudgetBloc({
    required this.getBudgetCategoriesUseCase,
  }) : super(BudgetInitial()) {
    on<LoadBudgetsEvent>((event, emit) async {
      emit(BudgetLoading());

      try {
        final categories = await getBudgetCategoriesUseCase();
        emit(BudgetLoaded(categories));
      } catch (e) {
        emit(BudgetError(e.toString()));
      }
    });

    add(LoadBudgetsEvent());
  }
}