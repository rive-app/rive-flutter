import 'package:rive/rive.dart';

/// A data bind option for a Rive file.
sealed class DataBind {
  const DataBind();

  /// Auto-bind
  static DataBind auto() => const AutoBind();

  /// Bind by view model instance
  static DataBind byInstance(ViewModelInstance viewModelInstance) =>
      BindByInstance(viewModelInstance);

  /// Bind by index
  static DataBind byIndex(int value) => BindByIndex(value);

  /// Bind by name
  static DataBind byName(String value) => BindByName(value);

  /// Empty binding
  static DataBind empty() => const BindEmpty();
}

/// Auto-bind with a boolean value
class AutoBind extends DataBind {
  const AutoBind();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutoBind && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'AutoBind()';
}

/// Bind by view model instance
class BindByInstance extends DataBind {
  final ViewModelInstance viewModelInstance;

  const BindByInstance(this.viewModelInstance);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BindByInstance &&
          runtimeType == other.runtimeType &&
          viewModelInstance == other.viewModelInstance;

  @override
  int get hashCode => viewModelInstance.hashCode;

  @override
  String toString() => 'BindByInstance(viewModelInstance: $viewModelInstance)';
}

/// Bind by index with a number value
class BindByIndex extends DataBind {
  final int index;

  const BindByIndex(this.index);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BindByIndex &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => index.hashCode;

  @override
  String toString() => 'BindByIndex(value: $index)';
}

/// Bind by name with a string value
class BindByName extends DataBind {
  final String name;

  const BindByName(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BindByName &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'BindByName(value: $name)';
}

/// Empty binding
class BindEmpty extends DataBind {
  const BindEmpty();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BindEmpty && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'BindEmpty()';
}
