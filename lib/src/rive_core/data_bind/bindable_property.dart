import 'package:rive/src/generated/data_bind/bindable_property_base.dart';

export 'package:rive/src/generated/data_bind/bindable_property_base.dart';

enum PropertyType {
  number,
  string,
  boolean,
  enumerator,
  color,
}

class BindableProperty extends BindablePropertyBase {
  @override
  void onAddedDirty() {}

  @override
  void onAdded() {}
}
