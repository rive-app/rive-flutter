import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value.dart';

import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_string.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

class ContextValueString extends ContextValue {
  ContextValueString(ViewModelInstanceValue? source)
      : super(source as ViewModelInstanceString);
  @override
  void apply(Core<CoreContext> core, int propertyKey) {
    if (source?.coreType == ViewModelInstanceStringBase.typeKey) {
      final sourceString = source as ViewModelInstanceString;

      RiveCoreContext.setString(core, propertyKey, sourceString.propertyValue);
    }
  }

  @override
  void applyToSource(Core<CoreContext> core, int propertyKey) {
    final value = RiveCoreContext.getString(core, propertyKey);
    final sourceString = source as ViewModelInstanceString;
    sourceString.propertyValue = value;
  }
}
