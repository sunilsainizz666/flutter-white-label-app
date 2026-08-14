import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_white_list/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('accepts valid email addresses', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('u.ser+tag@sub.example.co'), isNull);
    });

    test('rejects invalid or empty email addresses', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('foo@bar'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('accepts strong passwords', () {
      expect(Validators.password('Str0ngPass'), isNull);
    });

    test('rejects weak passwords', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('alllowercase1'), isNotNull);
      expect(Validators.password('ALLUPPERCASE1'), isNotNull);
      expect(Validators.password('NoDigitsHere'), isNotNull);
    });
  });

  group('Validators.required', () {
    test('rejects empty and null', () {
      expect(Validators.required(null), isNotNull);
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('   '), isNotNull);
    });

    test('accepts non-empty', () {
      expect(Validators.required('value'), isNull);
    });
  });
}
