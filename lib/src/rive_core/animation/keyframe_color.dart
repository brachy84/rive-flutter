import 'dart:ui';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyframe_interpolation.dart';
import 'package:rive/src/generated/animation/keyframe_color_base.dart';
import 'package:rive/src/generated/rive_core_context.dart';
export 'package:rive/src/generated/animation/keyframe_color_base.dart';

void _apply(Core<CoreContext> object, int propertyKey, double mix, int value) {
  if (mix == 1) {
    RiveCoreContext.setColor(object, propertyKey, value);
  } else {
    var mixedColor = Color.lerp(
        Color(RiveCoreContext.getColor(object, propertyKey)),
        Color(value),
        mix);
    RiveCoreContext.setColor(object, propertyKey, mixedColor.value);
  }
}

class KeyFrameColor extends KeyFrameColorBase {
  @override
  void apply(Core<CoreContext> object, int propertyKey, double mix) =>
      _apply(object, propertyKey, mix, value);
  @override
  void onAdded() {
    super.onAdded();
    interpolation ??= KeyFrameInterpolation.linear;
  }

  @override
  void applyInterpolation(Core<CoreContext> object, int propertyKey,
      double currentTime, KeyFrameColor nextFrame, double mix) {
    var f = (currentTime - seconds) / (nextFrame.seconds - seconds);
    if (interpolator != null) {
      f = interpolator.transform(f);
    }
    _apply(object, propertyKey, mix,
        Color.lerp(Color(value), Color(nextFrame.value), f).value);
  }

  @override
  void valueChanged(int from, int to) {}
}
