import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_settings.dart';
import '../../domain/usecases/update_setting.dart';
import 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final GetUserSettings getUserSettings;
  final UpdateSetting updateSetting;

  SettingCubit({
    required this.getUserSettings,
    required this.updateSetting,
  }) : super(SettingInitial());

  Future<void> loadSettings() async {
    emit(SettingLoading());
    try {
      final settings = await getUserSettings();
      emit(SettingLoaded(settings));
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }

  Future<void> toggleAutoSync(bool value) async {
    if (state is SettingLoaded) {
      final current = (state as SettingLoaded).settings;
      final updated = current.copyWith(autoSync: value);
      await updateSetting(updated);
      emit(SettingLoaded(updated));
    }
  }

  Future<void> toggleBudgetReminders(bool value) async {
    if (state is SettingLoaded) {
      final current = (state as SettingLoaded).settings;
      final updated = current.copyWith(budgetReminders: value);
      await updateSetting(updated);
      emit(SettingLoaded(updated));
    }
  }

  Future<void> toggleFaceIdLock(bool value) async {
    if (state is SettingLoaded) {
      final current = (state as SettingLoaded).settings;
      final updated = current.copyWith(faceIdLock: value);
      await updateSetting(updated);
      emit(SettingLoaded(updated));
    }
  }

  Future<void> triggerSync() async {
    if (state is SettingLoaded) {
      final current = (state as SettingLoaded).settings;
      final updated = current.copyWith(pendingChanges: 0);
      await updateSetting(updated);
      emit(SettingLoaded(updated));
    }
  }
}