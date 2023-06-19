import 'package:rive/src/rive_core/component.dart';

abstract class TextModifierBase extends Component {
  static const int typeKey = 160;
  @override
  int get coreType => TextModifierBase.typeKey;
  @override
  Set<int> get coreTypes => {TextModifierBase.typeKey, ComponentBase.typeKey};
}
