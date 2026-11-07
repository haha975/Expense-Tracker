import '../entities/user_settings.dart';
import '../repositories/setting_repository.dart';

class UpdateSetting {
  final SettingRepository repository;
  UpdateSetting(this.repository);

  Future<void> call(UserSettings settings) async {
    return await repository.updateSettings(settings);
  }
}