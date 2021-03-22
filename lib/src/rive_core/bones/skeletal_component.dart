import 'package:rive/src/generated/bones/skeletal_component_base.dart';
export 'package:rive/src/generated/bones/skeletal_component_base.dart';

class _UnknownSkeletalComponent extends SkeletalComponent {
  @override
  double x = 0;
  @override
  double y = 0;
}

// ignore: avoid_classes_with_only_static_members
abstract class SkeletalComponent extends SkeletalComponentBase {
  static final SkeletalComponent unknown = _UnknownSkeletalComponent();
}
