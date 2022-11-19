import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive_common/utilities.dart';

class CoreUintType extends CoreFieldType<int> {
  @override
  int deserialize(BinaryReader reader) => reader.readVarUint();
}
