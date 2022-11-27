import 'dart:math';
import 'package:flutter/cupertino.dart';

class Fish {
  final int id;
  final AnimationController controller;
  double x;

  Fish({
    required this.id,
    required this.controller,
    required this.x,
  });

  factory Fish.create(AnimationController controller, double x) {
    return Fish(id: Random().nextInt(99999), controller: controller, x: x-100);
  }

  void dispose() {
    controller.dispose();
  }

  void move() {
    x -=1;
  }
}
