import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive_common/utilities.dart';

class CoreBoolType extends CoreFieldType<bool> {
  @override
  bool deserialize(BinaryReader reader) => reader.readInt8() == 1;
}
