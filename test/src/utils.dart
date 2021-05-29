import 'dart:io';
import 'dart:typed_data';

/// Loads a Rive file from the assets sub-folder
ByteData loadFile(String filename) {
  final file = File(
      './${Directory.current.path.endsWith('/test') ? '' : 'test/'}$filename');
  return ByteData.sublistView(file.readAsBytesSync());
}
