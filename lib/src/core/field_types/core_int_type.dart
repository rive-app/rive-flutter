import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';

class CoreIntType extends CoreFieldType<int> {
  @override
  int deserialize(BinaryReader reader) => reader.readVarUint();
}
