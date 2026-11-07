import '../entities/user_settings.dart';

abstract class SettingRepository {
  Future<UserSettings> getSettings();
  Future<void> updateSettings(UserSettings settings);
}