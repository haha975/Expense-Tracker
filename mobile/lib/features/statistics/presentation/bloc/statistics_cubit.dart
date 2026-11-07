import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_statistics_usecase.dart';
import '../../domain/entities/statistics_entity.dart';

abstract class StatisticsState {}
class StatisticsInitial extends StatisticsState {}
class StatisticsLoading extends StatisticsState {}
class StatisticsLoaded extends StatisticsState {
  final StatisticsEntity statistics;
  StatisticsLoaded(this.statistics);
}
class StatisticsError extends StatisticsState {
  final String message;
  StatisticsError(this.message);
}

class StatisticsCubit extends Cubit<StatisticsState> {
  final GetStatisticsUseCase getStatisticsUseCase;

  StatisticsCubit(this.getStatisticsUseCase) : super(StatisticsInitial());

  
  Future<void> fetchStatistics(String period) async {
    // Show the full-page loader only on the first load.
    // When statistics are already visible, keep them on screen.
    if (state is! StatisticsLoaded) {
      emit(StatisticsLoading());
    }

    try {
      final stats = await getStatisticsUseCase(period);
      emit(StatisticsLoaded(stats));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

}