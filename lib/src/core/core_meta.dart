// import 'package:rive/src/generated/animation/keyframe_base.dart';
//
// import '../rive_core/container_component.dart';
//
// final _map = <CoreMeta, CoreMeta>{};
//
// abstract class CoreMetas {
//   static final CoreMeta frameInitialValue = CoreMeta._(frame: KeyFrameBase.frameInitialValue);
// }
//
// @immutable
// class CoreMeta extends Object {
//
//   final int frame;
//
//   @override
//   final int hashCode;
//
//   CoreMeta._({required this.frame}):
//         hashCode = frame {
//     _map[this] = this;
//     if (_map.length % 100 == 0) {
//       print('MAP LENGTH > ${_map.length} > $frame >> $hashCode');
//     }
//   }
//
//   @override
//   bool operator ==(Object other) => other is CoreMeta &&
//       other.frame == frame;
//
//   CoreMeta _copy({
//     int? frame,
//   }) => CoreMeta._(
//       frame: frame??this.frame,
//   );
//
//   CoreMeta setFrame(int frame) => _map[_copy(frame: frame)]!;
// }