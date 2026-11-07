class UserSettings {
  final String userName;
  final String userEmail;
  final bool isOnline;
  final String lastSyncTime;
  final int pendingChanges;
  final bool autoSync;
  final String currency;
  final String appearance;
  final int categoriesCount;
  final bool budgetReminders;
  final bool faceIdLock;

  const UserSettings({
    required this.userName,
    required this.userEmail,
    required this.isOnline,
    required this.lastSyncTime,
    required this.pendingChanges,
    required this.autoSync,
    required this.currency,
    required this.appearance,
    required this.categoriesCount,
    required this.budgetReminders,
    required this.faceIdLock,
  });

  UserSettings copyWith({
    bool? autoSync,
    bool? budgetReminders,
    bool? faceIdLock,
    int? pendingChanges,
  }) {
    return UserSettings(
      userName: userName,
      userEmail: userEmail,
      isOnline: isOnline,
      lastSyncTime: lastSyncTime,
      pendingChanges: pendingChanges ?? this.pendingChanges,
      autoSync: autoSync ?? this.autoSync,
      currency: currency,
      appearance: appearance,
      categoriesCount: categoriesCount,
      budgetReminders: budgetReminders ?? this.budgetReminders,
      faceIdLock: faceIdLock ?? this.faceIdLock,
    );
  }
}