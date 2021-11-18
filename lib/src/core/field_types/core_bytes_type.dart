import 'dart:typed_data';

import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';

class CoreBytesType extends CoreFieldType<Uint8List> {
  @override
  Uint8List deserialize(BinaryReader reader) {
    var length = reader.readVarUint();
    return reader.read(length);
  }
}
