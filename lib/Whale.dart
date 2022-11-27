import 'dart:math';

import 'package:flutter/cupertino.dart';

class Whale {
  final int id;
  final AnimationController controller;


  Whale({
    required this.id,
    required this.controller
  });

  factory Whale.create(AnimationController controller) {
    return Whale(id: Random().nextInt(99999), controller: controller);
  }

  void dispose() {
    controller.dispose();
  }
}
