import 'package:rive/rive.dart';

/// A data bind option for a Rive file.
sealed class DataBind {
  const DataBind();

  /// Whether the caller retains ownership of the resolved instance: true for
  /// [DataBind.byInstance] (the caller created it, the runtime never disposes
  /// it), false for variants the runtime resolves on the caller's behalf.
  bool get callerOwnsInstance => this is BindByInstance;

  /// Bind a fresh default instance. For a slot that is already bound, this
  /// replaces it with a new default (reset).
  static DataBind auto() => const AutoBind();

  /// Bind [viewModelInstance] - an instance you created
  /// ([BindableViewModelInstance], returned by `ViewModel.createInstance`
  /// and its siblings). The caller keeps ownership; the runtime never
  /// disposes instances passed this way. Read-backs are plain
  /// [ViewModelInstance] views and cannot be passed here (nor bound via a
  /// cast - that throws). Create your own instance to share state across
  /// slots or controllers.
  static DataBind byInstance(BindableViewModelInstance viewModelInstance) =>
      BindByInstance(viewModelInstance);

  /// Create and bind a fresh copy of the view model's instance at [value].
  /// Each call creates a new instance with that definition's authored
  /// values; runtime changes to a previously bound copy do not carry over.
  static DataBind byIndex(int value) => BindByIndex(value);

  /// Create and bind a fresh copy of the view model's instance named
  /// [value]. Each call creates a new instance with that definition's
  /// authored values; runtime changes to a previously bound copy do not
  /// carry over.
  static DataBind byName(String value) => BindByName(value);

  /// Bind a fresh blank instance of the slot's view model: the properties
  /// exist, but none of the editor-authored default values are applied.
  /// Despite the name this binds - it does not clear or unbind the slot
  /// (there is deliberately no unbind). To reset a slot instead, use [auto]
  /// for the editor-authored defaults or [empty] for a blank slate.
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
  final BindableViewModelInstance viewModelInstance;

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
