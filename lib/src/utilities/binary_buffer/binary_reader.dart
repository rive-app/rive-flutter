import 'dart:convert';
import 'dart:typed_data';

class BinaryReader {
  final _utf8Decoder = const Utf8Decoder();
  final ByteData buffer;
  final Endian endian;

  /// TODO: remove setter for readIndex when we remove _readVarInt from
  /// core_double_type.dart
  int readIndex = 0;

  int get position => readIndex;

  BinaryReader(this.buffer, {this.endian = Endian.little});

  BinaryReader.fromList(Uint8List list, {this.endian = Endian.little})
      : buffer =
            ByteData.view(list.buffer, list.offsetInBytes, list.lengthInBytes);

  bool get isEOF => readIndex >= buffer.lengthInBytes;

  double readFloat32() {
    double value = buffer.getFloat32(readIndex, endian);
    readIndex += 4;
    return value;
  }

  double readFloat64() {
    double value = buffer.getFloat64(readIndex, endian);
    readIndex += 8;
    return value;
  }

  int readInt8() {
    int value = buffer.getInt8(readIndex);
    readIndex += 1;
    return value;
  }

  int readUint8() {
    int value = buffer.getUint8(readIndex);
    readIndex += 1;
    return value;
  }

  int readInt16() {
    int value = buffer.getInt16(readIndex, endian);
    readIndex += 2;
    return value;
  }

  int readUint16() {
    int value = buffer.getUint16(readIndex, endian);
    readIndex += 2;
    return value;
  }

  int readInt32() {
    int value = buffer.getInt32(readIndex, endian);
    readIndex += 4;
    return value;
  }

  int readUint32() {
    int value = buffer.getUint32(readIndex, endian);
    readIndex += 4;
    return value;
  }

  int readInt64() {
    int value = buffer.getInt64(readIndex, endian);
    readIndex += 8;
    return value;
  }

  int readUint64() {
    int value = buffer.getUint64(readIndex, endian);
    readIndex += 8;
    return value;
  }

  /// Read a variable length unsigned integer from the buffer encoded as an
  /// LEB128 unsigned integer.
  int readVarUint() {
    int result = 0;
    int shift = 0;
    while (true) {
      int byte = buffer.getUint8(readIndex++) & 0xff;
      result |= (byte & 0x7f) << shift;
      if ((byte & 0x80) == 0) break;
      shift += 7;
    }
    return result;
  }

  /// Read a string encoded into the stream. Strings are encoded with a varuint
  /// integer length written first followed by length number of utf8 encoded
  /// bytes.
  String readString({bool explicitLength = true}) {
    int length = explicitLength ? readVarUint() : buffer.lengthInBytes;
    String value = _utf8Decoder.convert(Uint8List.view(
        buffer.buffer, buffer.offsetInBytes + readIndex, length));
    readIndex += length;
    return value;
  }

  Uint8List read(int length, [bool allocNew = true]) {
    var view =
        Uint8List.view(buffer.buffer, buffer.offsetInBytes + readIndex, length);
    readIndex += length;
    return allocNew ? Uint8List.fromList(view) : view;
  }
}
