import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';
import 'package:rive/src/utilities/binary_buffer/binary_writer.dart';

void main() {
  test('float32', () {
    var writer = BinaryWriter();
    writer.writeFloat32(1.5);
    writer.writeFloat32(3.1449999809265137);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readFloat32(), 1.5);
    expect(reader.readFloat32(), 3.1449999809265137);
  });

  test('float64', () {
    var writer = BinaryWriter();
    writer.writeFloat32(2.222222328186035);
    writer.writeFloat32(3.1456665992736816);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readFloat32(), 2.222222328186035);
    expect(reader.readFloat32(), 3.1456665992736816);
  });

  test('uint8', () {
    var writer = BinaryWriter();
    writer.writeUint8(7);
    writer.writeUint8(31);
    writer.writeUint8(222);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readUint8(), 7);
    expect(reader.readUint8(), 31);
    expect(reader.readUint8(), 222);
  });

  test('int8', () {
    var writer = BinaryWriter();
    writer.writeInt8(7);
    writer.writeInt8(31);
    writer.writeInt8(-127);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readInt8(), 7);
    expect(reader.readInt8(), 31);
    expect(reader.readInt8(), -127);
  });

  test('uint8', () {
    var writer = BinaryWriter();
    writer.writeUint8(7);
    writer.writeUint8(31);
    writer.writeUint8(222);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readUint8(), 7);
    expect(reader.readUint8(), 31);
    expect(reader.readUint8(), 222);
  });

  test('int16', () {
    var writer = BinaryWriter();
    writer.writeInt16(7);
    writer.writeInt16(31);
    writer.writeInt16(1982);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readInt16(), 7);
    expect(reader.readInt16(), 31);
    expect(reader.readInt16(), 1982);

    writer = BinaryWriter(endian: Endian.big);
    writer.writeInt16(7);
    writer.writeInt16(31);
    writer.writeInt16(1982);

    reader = BinaryReader(writer.buffer, endian: Endian.big);
    expect(reader.readInt16(), 7);
    expect(reader.readInt16(), 31);
    expect(reader.readInt16(), 1982);
  });

  test('uint16', () {
    var writer = BinaryWriter();
    writer.writeUint16(7);
    writer.writeUint16(31);
    writer.writeUint16(1982);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readUint16(), 7);
    expect(reader.readUint16(), 31);
    expect(reader.readUint16(), 1982);

    writer = BinaryWriter(endian: Endian.big);
    writer.writeUint16(7);
    writer.writeUint16(31);
    writer.writeUint16(1982);

    reader = BinaryReader(writer.buffer, endian: Endian.big);
    expect(reader.readUint16(), 7);
    expect(reader.readUint16(), 31);
    expect(reader.readUint16(), 1982);
  });

  test('int32', () {
    var writer = BinaryWriter();
    writer.writeInt32(7);
    writer.writeInt32(31);
    writer.writeInt32(1982);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readInt32(), 7);
    expect(reader.readInt32(), 31);
    expect(reader.readInt32(), 1982);

    writer = BinaryWriter(endian: Endian.big);
    writer.writeInt32(7);
    writer.writeInt32(31);
    writer.writeInt32(1982);

    reader = BinaryReader(writer.buffer, endian: Endian.big);
    expect(reader.readInt32(), 7);
    expect(reader.readInt32(), 31);
    expect(reader.readInt32(), 1982);
  });

  test('uint32', () {
    var writer = BinaryWriter();
    writer.writeUint32(7);
    writer.writeUint32(31);
    writer.writeUint32(4294967295);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readUint32(), 7);
    expect(reader.readUint32(), 31);
    expect(reader.readUint32(), 4294967295);

    writer = BinaryWriter(endian: Endian.big);
    writer.writeUint32(7);
    writer.writeUint32(31);
    writer.writeUint32(4294967295);

    reader = BinaryReader(writer.buffer, endian: Endian.big);
    expect(reader.readUint32(), 7);
    expect(reader.readUint32(), 31);
    expect(reader.readUint32(), 4294967295);
  });

  test('int64', () {
    var writer = BinaryWriter();
    writer.writeInt64(7);
    writer.writeInt64(31);
    writer.writeInt64(-9223372036854775807);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readInt64(), 7);
    expect(reader.readInt64(), 31);
    expect(reader.readInt64(), -9223372036854775807);

    writer = BinaryWriter(endian: Endian.big);
    writer.writeInt64(7);
    writer.writeInt64(31);
    writer.writeInt64(-9223372036854775807);

    reader = BinaryReader(writer.buffer, endian: Endian.big);
    expect(reader.readInt64(), 7);
    expect(reader.readInt64(), 31);
    expect(reader.readInt64(), -9223372036854775807);
  });

  test('uint64', () {
    var writer = BinaryWriter();
    writer.writeUint64(7);
    writer.writeUint64(31);
    writer.writeUint64(9223372036854775807);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readUint64(), 7);
    expect(reader.readUint64(), 31);
    expect(reader.readUint64(), 9223372036854775807);

    writer = BinaryWriter(endian: Endian.big);
    writer.writeUint64(7);
    writer.writeUint64(31);
    writer.writeUint64(9223372036854775807);

    reader = BinaryReader(writer.buffer, endian: Endian.big);
    expect(reader.readUint64(), 7);
    expect(reader.readUint64(), 31);
    expect(reader.readUint64(), 9223372036854775807);
  });

  test('varuint', () {
    var writer = BinaryWriter();
    writer.writeVarUint(7);
    writer.writeVarUint(127);
    writer.writeVarUint(8192);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readVarUint(), 7);
    expect(reader.readVarUint(), 127);
    expect(reader.readVarUint(), 8192);
  });

  test('string', () {
    var writer = BinaryWriter();
    writer.writeString("Node");
    writer.writeString("Artboard");

    var reader = BinaryReader(writer.buffer);
    expect(reader.readString(), "Node");
    expect(reader.readString(), "Artboard");
  });

  test('mixed', () {
    var writer = BinaryWriter();
    writer.writeVarUint(10);
    writer.writeString("Node");
    writer.writeFloat32(22.100000381469727);
    writer.writeFloat32(129.3000030517578);
    writer.writeInt32(1920);

    var reader = BinaryReader(writer.buffer);
    expect(reader.readVarUint(), 10);
    expect(reader.readString(), "Node");
    expect(reader.readFloat32(), 22.100000381469727);
    expect(reader.readFloat32(), 129.3000030517578);
    expect(reader.readInt32(), 1920);
  });

  test('bytes', () {
    var writer = BinaryWriter();
    writer.write(Uint8List.fromList([7, 31, 1982]));

    var reader = BinaryReader(writer.buffer);
    expect(reader.read(3), Uint8List.fromList([7, 31, 1982]));
  });

  test('a lot of bytes', () async {
    var writer = BinaryWriter();
    final bytesToWrite = Uint8List.fromList(
      // ~ 5MB, takes like 22 seconds on my mac the old way vs 0.15 the new
      List<int>.generate(1024 * 1024 * 5, (int index) => index % 128,
          growable: true),
    );
    writer.write(bytesToWrite);

    var reader = BinaryReader(writer.buffer);
    expect(reader.read(bytesToWrite.length), bytesToWrite);
    // required to trigger timeout error
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }, timeout: const Timeout(Duration(seconds: 5)));
}
