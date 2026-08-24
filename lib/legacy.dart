/// Opt-in compatibility layer for APIs removed from the main library.
///
/// ```dart
/// import 'package:rive/legacy.dart';
/// ```
///
/// restores the removed members as deprecated extensions so existing code
/// compiles (with warnings) while it migrates. This library is frozen: it
/// will not gain members and will be removed in a future release - treat the
/// import itself as a migration TODO.
library;

import 'package:rive/rive.dart';

/// Restores the removed [RiveWidgetController] `dataBind` method.
extension RiveLegacyControllerDataBind on RiveWidgetController {
  /// Resolves [dataBind] against the artboard's default view model and
  /// binds it as the main view model instance, immediately, with the removed
  /// `dataBind` method's ownership contract: the caller owns the returned
  /// instance and is responsible for disposing it.
  ///
  /// One debug-only divergence from the removed method: this shim never
  /// fires the early-rebind debug warning.
  ///
  /// Prefer the controller constructor's `main` parameter (or `bind`): the
  /// controller already binds at construction, so this call always pays a
  /// second full rebind.
  @Deprecated(
    'Pass main to the RiveWidgetController constructor '
    '(or rebind later with bind) and read viewModelInstance',
  )
  BindableViewModelInstance dataBind(DataBind dataBind) {
    final viewModel = dataBind is BindByInstance
        ? null
        : file.defaultArtboardViewModel(artboard);
    try {
      final vmi = switch (dataBind) {
        AutoBind() => viewModel?.createDefaultInstance(),
        BindByInstance() =>
          dataBind.viewModelInstance.isDisposed
              ? null
              : dataBind.viewModelInstance,
        BindByIndex() => viewModel?.createInstanceByIndex(dataBind.index),
        BindByName() => viewModel?.createInstanceByName(dataBind.name),
        BindEmpty() => viewModel?.createInstance(),
      };
      if (vmi == null) {
        final message = switch (dataBind) {
          AutoBind() =>
            'Default view model instance not found. Make sure '
                'the instance is set to exported in the Rive Editor.',
          BindByInstance() =>
            'The provided view model instance has been disposed.',
          BindByIndex() =>
            'View model instance by index `${dataBind.index}` not found.',
          BindByName() =>
            'View model instance by name `${dataBind.name}` not found.',
          BindEmpty() =>
            'Something went wrong. Could not create a view model instance.',
        };
        throw RiveDataBindException(message);
      }
      stateMachine.bindViewModelInstance(vmi);
      return vmi;
    } finally {
      viewModel?.dispose();
    }
  }
}

/// Restores the removed [RiveLoaded] `viewModelInstance` getter.
extension RiveLegacyLoadedViewModelInstance on RiveLoaded {
  /// The currently bound main view model instance; a live read of
  /// [RiveWidgetController.viewModelInstance] - read it there instead.
  @Deprecated('Read controller.viewModelInstance instead')
  ViewModelInstance? get viewModelInstance => controller.viewModelInstance;
}
