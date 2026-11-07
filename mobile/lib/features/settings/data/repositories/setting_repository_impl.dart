import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/setting_repository.dart';
import '../models/user_settings_model.dart';

class SettingRepositoryImpl implements SettingRepository {
  // Simulating local cache or data source
  UserSettingsModel _cachedSettings = UserSettingsModel.initial();

  @override
  Future<UserSettings> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate DB latency
    return _cachedSettings;
  }

  @override
  Future<void> updateSettings(UserSettings settings) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cachedSettings = UserSettingsModel(
      userName: settings.userName,
      userEmail: settings.userEmail,
      isOnline: settings.isOnline,
      lastSyncTime: settings.lastSyncTime,
      pendingChanges: settings.pendingChanges,
      autoSync: settings.autoSync,
      currency: settings.currency,
      appearance: settings.appearance,
      categoriesCount: settings.categoriesCount,
      budgetReminders: settings.budgetReminders,
      faceIdLock: settings.faceIdLock,
    );
  }
}