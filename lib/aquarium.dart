import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gussuri/Whale.dart';
import 'component/Fish.dart';

class Aquarium extends StatefulWidget {
  const Aquarium({Key? key}) : super(key: key);

  @override
  _AquariumState createState() => _AquariumState();
}

class _AquariumState extends State<Aquarium> with TickerProviderStateMixin {
  late AnimationController controller;
  List<Whale> whales = [];
  List<Fish> fishes = [];

  final random = Random();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 60), () {
      addWhale();
    });
    Future.delayed(const Duration(seconds: 1), () {
      addFish();
    });
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
    double maxWidth = MediaQuery.of(context).size.width.toDouble();
    for (int i = 0; i < 50; i++) {
      var controller =
          AnimationController(duration: const Duration(seconds: 1), vsync: this)
            ..forward();
      var fish = Fish.create(controller, maxWidth);
      controller.addListener(() {
        if (fish.controller.isCompleted) {
          setState(() {});
          fish.move();
          // fish.controller.repeat();
        }
      });
      setState(() {});
      fishes.add(fish);
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxHeight = MediaQuery.of(context).size.height.toInt();

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
                    offset: const Offset(100.0, 0),
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
                    offset:
                        Offset(fish.x, random.nextInt(maxHeight).toDouble()),
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
