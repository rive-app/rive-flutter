import 'package:rive/src/generated/data_bind/data_bind_base.dart';
import 'package:rive/src/rive_core/component.dart';

export 'package:rive/src/generated/data_bind/data_bind_base.dart';

enum BindMode {
  oneWay,
  twoWay,
  oneWayToSource,
  once,
}

class DataBind extends DataBindBase {
  Component? target;

  @override
  void onAddedDirty() {
    target = context.resolve(targetId);
    super.onAddedDirty();
  }

  @override
  void update(int dirt) {
    // TODO: @hernan implement update
  }

  void updateSourceBinding() {}

  @override
  void propertyKeyChanged(int from, int to) {
    // TODO: @hernan implement propertyKeyChanged
  }

  @override
  void targetIdChanged(int from, int to) {
    // TODO: @hernan implement nameChanged
  }

  @override
  void modeValueChanged(int from, int to) {
    // TODO: @hernan implement nameChanged
  }
}
