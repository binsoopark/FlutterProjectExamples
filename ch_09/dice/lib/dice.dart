import 'dart:math';

import 'package:rive/rive.dart';

class Dice {
  static List<SimpleAnimation> animations = [
    SimpleAnimation('Set1'),
    SimpleAnimation('Set2'),
    SimpleAnimation('Set3'),
    SimpleAnimation('Set4'),
    SimpleAnimation('Set5'),
    SimpleAnimation('Set6'),
  ];

  static getRandomNumber() {
    var random = Random();
    int num = random.nextInt(5) + 1;
    return num;
  }

  static Map<int, SimpleAnimation> getRandomAnimation() {
    var random = Random();
    int num = random.nextInt(5);
    Map<int, SimpleAnimation> result = {num: animations[num]};
    return result;
  }

  static Future wait3seconds() {
    return new Future.delayed(const Duration(seconds: 3), () {});
  }

}
