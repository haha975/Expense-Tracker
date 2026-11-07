import '../entities/user_settings.dart';
import '../repositories/setting_repository.dart';

class GetUserSettings {
  final SettingRepository repository;
  GetUserSettings(this.repository);

  Future<UserSettings> call() async {
    return await repository.getSettings();
  }
}