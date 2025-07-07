/// A selector for a state machine in a Rive file.
sealed class StateMachineSelector {
  const StateMachineSelector();

  /// Selects the default state machine.
  factory StateMachineSelector.byDefault() => const StateMachineDefault();

  /// Selects the state machine with the given name.
  factory StateMachineSelector.byName(String name) => StateMachineNamed(name);

  /// Selects the state machine at the given index.
  factory StateMachineSelector.byIndex(int index) => StateMachineAtIndex(index);
}

/// Selects the default state machine.
class StateMachineDefault extends StateMachineSelector {
  const StateMachineDefault();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateMachineDefault && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'StateMachineDefault()';
}

/// Selects the state machine with the given name.
class StateMachineNamed extends StateMachineSelector {
  final String name;

  const StateMachineNamed(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateMachineNamed &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'StateMachineNamed(name: $name)';
}

/// Selects the state machine at the given index.
class StateMachineAtIndex extends StateMachineSelector {
  final int index;

  const StateMachineAtIndex(this.index);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateMachineAtIndex &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => index.hashCode;

  @override
  String toString() => 'StateMachineAtIndex(index: $index)';
}
