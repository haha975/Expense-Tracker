
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_goals_usecase.dart';
import 'goal_event.dart';
import 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GetGoalsUseCase getGoalsUseCase;

  GoalBloc({required this.getGoalsUseCase}) : super(GoalInitial()) {
    on<LoadGoalsEvent>((event, emit) async {
      emit(GoalLoading());

      try {
        final goals = await getGoalsUseCase();
        emit(GoalLoaded(goals));
      } catch (e) {
        emit(GoalError(e.toString()));
      }
    });

    // Load goals automatically when the bloc is created.
    add(LoadGoalsEvent());
  }
}
