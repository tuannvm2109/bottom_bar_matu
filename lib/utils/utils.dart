import 'package:flutter/material.dart';

class Utils {
  static double getAnimationOneWayValue(Animation animation) {
    final value = animation.value!;

    if (animation.status == AnimationStatus.dismissed) {
      return 1;
    }
    return animation.status == AnimationStatus.reverse ? 1 - value : value;
  }
}
