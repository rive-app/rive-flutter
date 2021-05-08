import 'dart:collection';

import 'package:rive/src/rive_core/runtime/exceptions/rive_format_error_exception.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_unsupported_version_exception.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';

/// Stores the minor and major version of Rive. Versions with the same major
/// value are backwards and forwards compatible.
class RuntimeVersion {
  final int major;
  final int minor;

  const RuntimeVersion(this.major, this.minor);
  String versionString() {
    return '$major.$minor';
  }
}

const riveVersion = RuntimeVersion(7, 0);

class RuntimeHeader {
  static const String fingerprint = 'RIVE';
  final RuntimeVersion version;

  final int fileId;

  final HashMap<int, int> propertyToFieldIndex;

  RuntimeHeader({
    required this.fileId,
    required this.version,
    required this.propertyToFieldIndex,
  });

  /// Read the header from a binary [reader]. Specify [version] to check
  /// compatibility while loading the header. You can also opt to provide null
  /// to skip version checking. Note that in this case the header can only be
  /// read if it's of a known major version (<= [riveVersion.major]).
  factory RuntimeHeader.read(
    BinaryReader reader, {
    RuntimeVersion? version = riveVersion,
  }) {
    var fingerprint = RuntimeHeader.fingerprint.codeUnits;

    for (int i = 0; i < fingerprint.length; i++) {
      if (reader.readUint8() != fingerprint[i]) {
        throw const RiveFormatErrorException('Fingerprint doesn\'t match.');
      }
    }

    int readMajorVersion = reader.readVarUint();
    int readMinorVersion = reader.readVarUint();

    if (version == null && readMajorVersion > riveVersion.major) {
      throw RiveUnsupportedVersionException(riveVersion.major,
          riveVersion.minor, readMajorVersion, readMinorVersion);
    } else if (version != null && readMajorVersion != version.major) {
      throw RiveUnsupportedVersionException(
          version.major, version.minor, readMajorVersion, readMinorVersion);
    }
    if (readMajorVersion == 6) {
      reader.readVarUint();
    }
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
      fileId: fileId,
      version: RuntimeVersion(readMajorVersion, readMinorVersion),
      propertyToFieldIndex: propertyFields,
    );
  }
}
