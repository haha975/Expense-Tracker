class Validators {
  Validators._();

  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static String? requiredField(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, fieldName: 'Email');
    if (requiredError != null) return requiredError;
    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    final requiredError = requiredField(value, fieldName: 'Password');
    if (requiredError != null) return requiredError;
    if (value!.length < minLength) {
      return 'Password must be at least $minLength characters.';
    }
    return null;
  }

  static String? amount(String? value) {
    final requiredError = requiredField(value, fieldName: 'Amount');
    if (requiredError != null) return requiredError;
    final parsed = double.tryParse(value!.trim().replaceAll(',', ''));
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid amount greater than zero.';
    }
    return null;
  }
}
