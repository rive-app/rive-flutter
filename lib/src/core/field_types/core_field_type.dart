import 'package:rive_common/utilities.dart';

// ignore: one_member_abstracts
abstract class CoreFieldType<T extends Object> {
  T deserialize(BinaryReader reader);
  void skip(BinaryReader reader) => deserialize(reader);
}
