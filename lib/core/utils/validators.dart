class Validators {
  Validators._();

  static final RegExp _emailRegex =
      RegExp(r"^[\w\-\.\+]+@([\w\-]+\.)+[\w\-]{2,}$");
  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'\d');

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (!_hasUppercase.hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }
    if (!_hasLowercase.hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }
    if (!_hasDigit.hasMatch(value)) {
      return 'Password must contain a digit';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Confirm password is required';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!_phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? minLength(String? value, int length, {String field = 'This field'}) {
    if (value == null || value.length < length) {
      return '$field must be at least $length characters';
    }
    return null;
  }

  static String? maxLength(String? value, int length, {String field = 'This field'}) {
    if (value != null && value.length > length) {
      return '$field must be at most $length characters';
    }
    return null;
  }

  static bool isEmail(String value) => _emailRegex.hasMatch(value.trim());
  static bool isPhone(String value) => _phoneRegex.hasMatch(value.trim());
}
