import 'dart:io' as io;

import 'package:rive/rive.dart';

/// Decodes the fixture at [assetPath] with the Flutter factory.
Future<File> decodeRiveFixture(String assetPath) async {
  return await File.decode(
        await io.File(assetPath).readAsBytes(),
        riveFactory: Factory.flutter,
      )
      as File;
}

/// Creates a default instance of the view model named [name], releasing the
/// intermediate [ViewModel] wrapper.
BindableViewModelInstance makeDefaultInstance(File file, String name) {
  final viewModel = file.viewModelByName(name)!;
  try {
    return viewModel.createDefaultInstance()!;
  } finally {
    viewModel.dispose();
  }
}
