import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive_common/utilities.dart';

class CoreStringType extends CoreFieldType<String> {
  @override
  String deserialize(BinaryReader reader) =>
      reader.readString(explicitLength: true);

  void read(BinaryReader reader) {
    var length = reader.readVarUint();
    reader.read(length);
  }
}
