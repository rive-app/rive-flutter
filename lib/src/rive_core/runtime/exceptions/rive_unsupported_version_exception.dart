import 'package:meta/meta.dart';

/// Error that occurs when a file being loaded doesn't match the importer's
/// supported version.
@immutable
class RiveUnsupportedVersionException implements Exception {
  final int majorVersion;
  final int minorVersion;
  final int fileMajorVersion;
  final int fileMinorVersion;
  const RiveUnsupportedVersionException(this.majorVersion, this.minorVersion,
      this.fileMajorVersion, this.fileMinorVersion);

  @override
  String toString() {
    return 'File contains version $fileMajorVersion.$fileMinorVersion. '
        'This runtime supports version $majorVersion.$minorVersion';
  }
}
