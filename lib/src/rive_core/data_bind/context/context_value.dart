import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

abstract class ContextValue {
  ViewModelInstanceValue? source;
  ContextValue(this.source);
  void apply(Core<CoreContext> core, int propertyKey);
  void applyToSource(Core<CoreContext> core, int propertyKey);
  void update(Core<CoreContext> core) {}
}
