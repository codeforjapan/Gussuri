import 'dart:math';
import 'package:flutter/material.dart';

class Fish extends StatefulWidget {
  const Fish({Key? key}) : super(key: key);

  @override
  _FishState createState() => _FishState();
}

class _FishState extends State<Fish>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final random = Random();

  @override
  void initState() {
    controller =
    AnimationController(duration: const Duration(milliseconds: 11500), vsync: this)
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double shake(double value) =>
      10 * (0.5 - (0.5 - Curves.bounceOut.transform(value)).abs());

  @override
  Widget build(BuildContext context) {
    // todo: 0から連続した数字を返すようにする時に使う
    int maxWidth = MediaQuery. of(context). size. width.toInt();
    int maxHeight = MediaQuery. of(context). size. height.toInt();

    return SafeArea(child:  AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(200 * shake(controller.value), 0),
        child: child,
      ),
      child: const Image(
        image: AssetImage('images/fish.gif'),
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      ),
    ));
  }
}
