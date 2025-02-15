import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/rive_core_beans.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value.dart';

import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_number.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

class ContextValueNumber extends ContextValue {
  ContextValueNumber(ViewModelInstanceValue? source) : super(source);

  @override
  void apply(Core<CoreContext> core, int propertyKey) {
    if (source?.coreType == ViewModelInstanceNumberBase.typeKey) {
      final sourceNumber = source as ViewModelInstanceNumber;

      PropertyBeans.get(propertyKey).setDouble(core, sourceNumber.propertyValue);
    }
  }

  @override
  void applyToSource(Core<CoreContext> core, int propertyKey) {
    final value = PropertyBeans.get(propertyKey).getDouble(core);
    final sourceNumber = source as ViewModelInstanceNumber;
    sourceNumber.propertyValue = value;
  }
}
