import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_unsupported_version_exception.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';
import 'exceptions/rive_format_error_exception.dart';

class RuntimeHeader {
  static const int majorVersion = 6;
  static const int minorVersion = 0;
  static const String fingerprint = 'RIVE';
  final int ownerId;
  final int fileId;
  final HashMap<int, int> propertyToFieldIndex;
  RuntimeHeader(
      {@required this.ownerId,
      @required this.fileId,
      @required this.propertyToFieldIndex});
  factory RuntimeHeader.read(BinaryReader reader) {
    var fingerprint = RuntimeHeader.fingerprint.codeUnits;
    for (int i = 0; i < fingerprint.length; i++) {
      if (reader.readUint8() != fingerprint[i]) {
        throw const RiveFormatErrorException('Fingerprint doesn\'t match.');
      }
    }
    int readMajorVersion = reader.readVarUint();
    int readMinorVersion = reader.readVarUint();
    if (readMajorVersion > majorVersion ||
        (readMajorVersion == majorVersion && readMinorVersion > minorVersion)) {
      throw RiveUnsupportedVersionException(
          majorVersion, minorVersion, readMajorVersion, readMinorVersion);
    }
    int ownerId = reader.readVarUint();
    int fileId = reader.readVarUint();
    var propertyFields = HashMap<int, int>();
    var propertyKeys = <int>[];
    for (int propertyKey = reader.readVarUint();
        propertyKey != 0;
        propertyKey = reader.readVarUint()) {
      propertyKeys.add(propertyKey);
    }
    int currentInt = 0;
    int currentBit = 8;
    for (final propertyKey in propertyKeys) {
      if (currentBit == 8) {
        currentInt = reader.readUint32();
        currentBit = 0;
      }
      int fieldIndex = (currentInt >> currentBit) & 3;
      propertyFields[propertyKey] = fieldIndex;
      currentBit += 2;
    }
    return RuntimeHeader(
        ownerId: ownerId, fileId: fileId, propertyToFieldIndex: propertyFields);
  }
}
