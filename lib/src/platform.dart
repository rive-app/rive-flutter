import 'platform_native.dart' if (dart.library.js_interop) 'platform_web.dart';

abstract class Platform {
  bool get isTesting;
  static final Platform instance = makePlatform();
}
