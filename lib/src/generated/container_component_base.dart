import 'package:rive/src/rive_core/component.dart';

abstract class ContainerComponentBase extends Component {
  static const int typeKey = 11;
  @override
  int get coreType => ContainerComponentBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ContainerComponentBase.typeKey, ComponentBase.typeKey};
}
