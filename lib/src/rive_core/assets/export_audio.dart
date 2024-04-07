import 'package:rive/src/generated/assets/export_audio_base.dart';
export 'package:rive/src/generated/assets/export_audio_base.dart';

abstract class ExportAudio extends ExportAudioBase {
  @override
  void volumeChanged(double from, double to) {}
}
