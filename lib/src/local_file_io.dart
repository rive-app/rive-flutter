import 'dart:io';
import 'dart:typed_data';

/// Load a list of bytes from a file on the local filesystem at [path].
Future<Uint8List?> localFileBytes(String path) => File(path).readAsBytes();
