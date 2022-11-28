import 'dart:math';
import 'package:flutter/cupertino.dart';

class Fish {
  final int id;
  final AnimationController controller;
  double x;
  double offsetX;
  double offsetY;

  Fish({
    required this.id,
    required this.controller,
    required this.x,
    required this.offsetX,
    required this.offsetY,
  });

  factory Fish.create(AnimationController controller, double x, double offsetX, double offsetY) {
    return Fish(id: Random().nextInt(99999), controller: controller, x: x-100, offsetX: offsetX, offsetY: offsetY);
  }

  void dispose() {
    controller.dispose();
  }

  void move() {
    x -=1;
  }
}
