import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';

abstract class CoreFieldType<T> {
  T deserialize(BinaryReader reader);
  T lerp(T from, T to, double f);
}
