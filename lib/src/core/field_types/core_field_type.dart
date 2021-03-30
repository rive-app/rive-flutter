import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';

// ignore: one_member_abstracts
abstract class CoreFieldType<T extends Object> {
  T deserialize(BinaryReader reader);
}
