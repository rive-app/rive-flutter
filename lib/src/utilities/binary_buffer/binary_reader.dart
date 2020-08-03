import 'dart:convert';
import 'dart:typed_data';

var _utf8Decoder = const Utf8Decoder();

class BinaryReader {
  final ByteData buffer;
  final Endian endian;
  int _readIndex = 0;
  int get position => _readIndex;

  BinaryReader(this.buffer, {this.endian = Endian.little});

  BinaryReader.fromList(Uint8List list, {this.endian = Endian.little})
      : buffer =
            ByteData.view(list.buffer, list.offsetInBytes, list.lengthInBytes);

  bool get isEOF => _readIndex >= buffer.lengthInBytes;

  double readFloat32() {
    double value = buffer.getFloat32(_readIndex, endian);
    _readIndex += 4;
    return value;
  }

  double readFloat64() {
    double value = buffer.getFloat64(_readIndex, endian);
    _readIndex += 8;
    return value;
  }

  int readInt8() {
    int value = buffer.getInt8(_readIndex);
    _readIndex += 1;
    return value;
  }

  int readUint8() {
    int value = buffer.getUint8(_readIndex);
    _readIndex += 1;
    return value;
  }

  int readInt16() {
    int value = buffer.getInt16(_readIndex, endian);
    _readIndex += 2;
    return value;
  }

  int readUint16() {
    int value = buffer.getUint16(_readIndex, endian);
    _readIndex += 2;
    return value;
  }

  int readInt32() {
    int value = buffer.getInt32(_readIndex, endian);
    _readIndex += 4;
    return value;
  }

  int readUint32() {
    int value = buffer.getUint32(_readIndex, endian);
    _readIndex += 4;
    return value;
  }

  int readInt64() {
    int value = buffer.getInt64(_readIndex, endian);
    _readIndex += 8;
    return value;
  }

  int readUint64() {
    int value = buffer.getUint64(_readIndex, endian);
    _readIndex += 8;
    return value;
  }

  /// Read a variable length signed integer from the buffer encoded as an LEB128
  /// signed integer.
  int readVarInt() {
    int result = 0;
    int shift = 0;
    while (true) {
      int byte = buffer.getUint8(_readIndex);
      result |= (byte & 0x7f) << shift;
      shift += 7;
      if ((byte & 0x80) == 0) {
        break;
      } else {
        _readIndex++;
      }
    }
    if ((shift < 64) && (buffer.getUint8(_readIndex) & 0x40) != 0) {
      result |= ~0 << shift;
    }
    _readIndex += 1;
    return result;
  }

  /// Read a variable length unsigned integer from the buffer encoded as an
  /// LEB128 unsigned integer.
  int readVarUint() {
    int result = 0;
    int shift = 0;
    while (true) {
      int byte = buffer.getUint8(_readIndex++) & 0xff;
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
        buffer.buffer, buffer.offsetInBytes + _readIndex, length));
    _readIndex += length;
    return value;
  }

  Uint8List read(int length, [bool allocNew = false]) {
    var view = Uint8List.view(
        buffer.buffer, buffer.offsetInBytes + _readIndex, length);
    _readIndex += length;
    return allocNew ? Uint8List.fromList(view) : view;
  }

  /// Read a list of encoded integers.
  List<int> readIntList() {
    int length = readVarUint();
    var list = List<int>(length);
    for (int i = 0; i < length; i++) {
      list[i] = readVarInt();
    }
    return list;
  }
}
