import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/rive_core_beans.dart';
import 'package:rive/src/rive_core/data_bind/context/context_value.dart';

import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_color.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_value.dart';

class ContextValueColor extends ContextValue {
  ContextValueColor(ViewModelInstanceValue? source) : super(source);

  @override
  void apply(Core<CoreContext> core, int propertyKey) {
    if (source?.coreType == ViewModelInstanceColorBase.typeKey) {
      final sourceColor = source as ViewModelInstanceColor;

      PropertyBeans.get(propertyKey).setColor(core, sourceColor.propertyValue);
    }
  }

  @override
  void applyToSource(Core<CoreContext> core, int propertyKey) {
    final value = PropertyBeans.get(propertyKey).getColor(core);
    final sourceColor = source as ViewModelInstanceColor;
    sourceColor.propertyValue = value;
  }
}
