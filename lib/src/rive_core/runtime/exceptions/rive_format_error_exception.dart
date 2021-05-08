import 'package:meta/meta.dart';

/// Thrown when a file being read doesn't match the Rive format.
@immutable
class RiveFormatErrorException implements Exception {
  final String cause;
  const RiveFormatErrorException(this.cause);
}
