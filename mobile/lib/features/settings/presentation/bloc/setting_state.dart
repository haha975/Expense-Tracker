import '../../domain/entities/user_settings.dart';

abstract class SettingState {}

class SettingInitial extends SettingState {}
class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final UserSettings settings;
  SettingLoaded(this.settings);
}

class SettingError extends SettingState {
  final String message;
  SettingError(this.message);
}