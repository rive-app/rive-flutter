/// A selector for an artboard in a Rive file.
sealed class ArtboardSelector {
  const ArtboardSelector();

  /// Selects the default artboard.
  factory ArtboardSelector.byDefault() => const ArtboardDefault();

  /// Selects the artboard with the given name.
  factory ArtboardSelector.byName(String name) => ArtboardNamed(name);

  /// Selects the artboard at the given index.
  factory ArtboardSelector.byIndex(int index) => ArtboardAtIndex(index);
}

/// Selects the default artboard.
class ArtboardDefault extends ArtboardSelector {
  const ArtboardDefault();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtboardDefault && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'ArtboardDefault()';
}

/// Selects the artboard with the given name.
class ArtboardNamed extends ArtboardSelector {
  final String name;

  const ArtboardNamed(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtboardNamed &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'ArtboardNamed(name: $name)';
}

/// Selects the artboard at the given index.
class ArtboardAtIndex extends ArtboardSelector {
  final int index;

  const ArtboardAtIndex(this.index);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtboardAtIndex &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => index.hashCode;

  @override
  String toString() => 'ArtboardAtIndex(index: $index)';
}
