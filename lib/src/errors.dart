/// A base class for all Rive exceptions.
class RiveException implements Exception {
  RiveException(this.message);
  final String message;
}

/// An exception that is thrown when a Rive FileLoader fails to load.
class RiveFileLoaderException extends RiveException {
  RiveFileLoaderException(super.message);

  @override
  String toString() {
    return 'RiveFileLoaderException: $message';
  }
}

/// An exception that is thrown when a Rive Artboard fails to load.
class RiveArtboardException extends RiveException {
  RiveArtboardException(super.message);

  @override
  String toString() {
    return 'RiveArtboardException: $message';
  }
}

/// An exception that is thrown when a Rive State Machine fails to load.
class RiveStateMachineException extends RiveException {
  RiveStateMachineException(super.message);

  @override
  String toString() {
    return 'RiveStateMachineException: $message';
  }
}

/// An exception that is thrown when a data bind fails.
class RiveDataBindException extends RiveException {
  RiveDataBindException(super.message);

  @override
  String toString() {
    return 'RiveDataBindException: $message';
  }
}
