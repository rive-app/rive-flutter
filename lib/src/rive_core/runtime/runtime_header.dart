import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_unsupported_version_exception.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';
import 'exceptions/rive_format_error_exception.dart';

class RuntimeHeader {
  static const int majorVersion = 2;
  static const int minorVersion = 0;
  static const String fingerprint = 'RIVE';
  final int ownerId;
  final int fileId;
  RuntimeHeader({@required this.ownerId, @required this.fileId});
  factory RuntimeHeader.read(BinaryReader reader) {
    var fingerprint = RuntimeHeader.fingerprint.codeUnits;
    for (int i = 0; i < fingerprint.length; i++) {
      if (reader.readUint8() != fingerprint[i]) {
        throw const RiveFormatErrorException('Fingerprint doesn\'t match.');
      }
    }
    int readMajorVersion = reader.readVarUint();
    int readMinorVersion = reader.readVarUint();
    if (readMajorVersion > majorVersion) {
      throw RiveUnsupportedVersionException(
          majorVersion, minorVersion, readMajorVersion, readMinorVersion);
    }
    int ownerId = reader.readVarUint();
    int fileId = reader.readVarUint();
    return RuntimeHeader(ownerId: ownerId, fileId: fileId);
  }
}
