import 'package:uuid/uuid.dart';

class IdGenerator {
  IdGenerator._();

  static const Uuid _uuid = Uuid();

  static String uuid() => _uuid.v4();

  static String fileName(String extension) {
    final ext = extension.startsWith('.') ? extension.substring(1) : extension;
    return '${_uuid.v4()}.$ext';
  }
}
