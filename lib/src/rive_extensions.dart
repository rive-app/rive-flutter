import 'package:rive/rive.dart' as rive;

extension RiveFileExtension on rive.File {
  /// Creates a default view model instance for the given artboard.
  ///
  /// This is a convenience method that gets the default view model, and
  /// creates a default view model instance for the given artboard.
  ///
  /// Returns `null` if the artboard does not have a default view model.
  ///
  /// Example:
  /// ```dart
  /// final viewModelInstance = riveFile.createDefaultViewModelInstance(artboard);
  /// ```
  rive.ViewModelInstance? createDefaultViewModelInstance(
          rive.Artboard artboard) =>
      defaultArtboardViewModel(artboard)?.createDefaultInstance();
}
