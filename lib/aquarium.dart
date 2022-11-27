import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gussuri/Whale.dart';
import 'component/Fish.dart';

class Aquarium extends StatefulWidget {
  const Aquarium({Key? key}) : super(key: key);

  @override
  _AquariumState createState() => _AquariumState();
}

class _AquariumState extends State<Aquarium>
    with TickerProviderStateMixin {
  late AnimationController controller;
  List<Whale> whales = [];
  List<Fish> fishes = [];

  final random = Random();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 60), () {
      addWhale();
    });
    addFish();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double shake(double value) =>
      1 * (0.5 - (0.5 - Curves.bounceOut.transform(value)).abs());

  void addWhale() {
    setState(() {
      whales.add(Whale.create(
          AnimationController(duration: const Duration(seconds: 2), vsync: this)
            ..forward()
            ..addListener(() {
              if (whales.first.controller.isCompleted) {
                setState(() {
                  whales.first.dispose();
                  whales.clear();
                });
              }
            })));
    });
  }

  void addFish() {
    for(int i = 0; i < 50; i++) {
      setState(() {
        fishes.add(Fish.create(
            AnimationController(duration: const Duration(seconds: 1), vsync: this)
              ..forward()
              ..addListener(() {
                // todo: last以外も対応させたい
                if (fishes.last.controller.isCompleted) {
                  fishes.last.controller.repeat();
                }
              })));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxWidth = MediaQuery. of(context). size. width.toInt();
    int maxHeight = MediaQuery. of(context). size. height.toInt();

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.cover)),
        ),
        SafeArea(
            child: Stack(
          children: [
            ...whales.map((whale) => AnimatedBuilder(
              animation: whale.controller,
              builder: (context, child) => Transform.translate(
                offset: const Offset(100.0 , 0),
                child: child,
              ),
              child: const Image(
                image: AssetImage('images/whale.png'),
                height: 600,
                width: 800,
                fit: BoxFit.contain,
              ),
            )),
            ...fishes.map((fish) => AnimatedBuilder(
              animation: fish.controller,
              builder: (context, child) => Transform.translate(
                offset: Offset(random.nextInt(maxWidth).toDouble(), random.nextInt(maxHeight).toDouble()),
                child: child,
              ),
              child: const Image(
                image: AssetImage('images/fish.gif'),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            )),
          ],
        )),
      ],
    );
  }
}
