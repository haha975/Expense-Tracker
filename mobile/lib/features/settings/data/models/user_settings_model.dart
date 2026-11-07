import '../../domain/entities/user_settings.dart';

class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    required super.userName,
    required super.userEmail,
    required super.isOnline,
    required super.lastSyncTime,
    required super.pendingChanges,
    required super.autoSync,
    required super.currency,
    required super.appearance,
    required super.categoriesCount,
    required super.budgetReminders,
    required super.faceIdLock,
  });

  factory UserSettingsModel.initial() {
    return const UserSettingsModel(
      userName: 'Alex Morgan',
      userEmail: 'alex.morgan@email.com',
      isOnline: true,
      lastSyncTime: 'Today, 9:41 AM',
      pendingChanges: 0,
      autoSync: true,
      currency: 'USD • \$',
      appearance: 'Dark',
      categoriesCount: 10,
      budgetReminders: true,
      faceIdLock: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoSync': autoSync,
      'budgetReminders': budgetReminders,
      'faceIdLock': faceIdLock,
      'pendingChanges': pendingChanges,
    };
  }
}