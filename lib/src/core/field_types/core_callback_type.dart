import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive_common/utilities.dart';

class CallbackData {
  final Object? context;
  final double delay;
  CallbackData(
    this.context, {
    required this.delay,
  });
}

class CoreCallbackType extends CoreFieldType<int> {
  @override
  int deserialize(BinaryReader reader) => 0;
}
