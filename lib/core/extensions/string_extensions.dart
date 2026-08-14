import '../utils/validators.dart';

extension StringNullableExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

extension StringExtensions on String {
  bool get isValidEmail => Validators.isEmail(this);
  bool get isValidPhone => Validators.isPhone(this);

  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get titleCase => split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w.capitalized)
      .join(' ');

  String truncate(int max, {String suffix = '…'}) =>
      length <= max ? this : '${substring(0, max)}$suffix';
}
