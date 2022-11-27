import 'dart:math';
import 'package:flutter/cupertino.dart';

class Fish {
  final int id;
  final AnimationController controller;

  Fish({
    required this.id,
    required this.controller
  });

  factory Fish.create(AnimationController controller) {
    return Fish(id: Random().nextInt(99999), controller: controller);
  }

  void dispose() {
    controller.dispose();
  }
}
