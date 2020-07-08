import 'package:meta/meta.dart';

@immutable
class RiveFormatErrorException implements Exception {
  final String cause;
  const RiveFormatErrorException(this.cause);
}
