import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value.dart';

import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_number.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

class ContextValueNumber extends ContextValue {
  ContextValueNumber(ViewModelInstanceValue? source) : super(source);

  @override
  void apply(Core<CoreContext> core, int propertyKey) {
    if (source?.coreType == ViewModelInstanceNumberBase.typeKey) {
      final sourceNumber = source as ViewModelInstanceNumber;

      RiveCoreContext.setDouble(core, propertyKey, sourceNumber.propertyValue);
    }
  }

  @override
  void applyToSource(Core<CoreContext> core, int propertyKey) {
    final value = RiveCoreContext.getDouble(core, propertyKey);
    final sourceNumber = source as ViewModelInstanceNumber;
    sourceNumber.propertyValue = value;
  }
}
