import 'package:meta/meta.dart';

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
        'This runtime can only support $fileMajorVersion.$fileMinorVersion';
  }
}
