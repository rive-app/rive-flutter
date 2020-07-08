
import 'package:rive/src/core/core.dart';
import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';


class CoreFractionalIndexType extends CoreFieldType<FractionalIndex> {
  @override
  FractionalIndex deserialize(BinaryReader reader) {
    var numerator = reader.readVarInt();
    var denominator = reader.readVarInt();
    return FractionalIndex(numerator, denominator);
  }

  @override
  FractionalIndex lerp(FractionalIndex from, FractionalIndex to, double f) =>
      from;
}
