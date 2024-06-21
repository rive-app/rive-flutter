import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value.dart';

import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_boolean.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

class ContextValueBoolean extends ContextValue {
  ContextValueBoolean(ViewModelInstanceValue? source) : super(source);

  @override
  void apply(Core<CoreContext> core, int propertyKey) {
    if (source?.coreType == ViewModelInstanceBooleanBase.typeKey) {
      final sourceBoolean = source as ViewModelInstanceBoolean;

      RiveCoreContext.setBool(core, propertyKey, sourceBoolean.propertyValue);
    }
  }

  @override
  void applyToSource(Core<CoreContext> core, int propertyKey) {
    final value = RiveCoreContext.getBool(core, propertyKey);
    final sourceBoolean = source as ViewModelInstanceBoolean;
    sourceBoolean.propertyValue = value;
  }
}
