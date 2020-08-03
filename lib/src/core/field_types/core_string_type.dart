import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';

class CoreStringType extends CoreFieldType<String> {
  @override
  String deserialize(BinaryReader reader) =>
      reader.readString(explicitLength: true);
}
