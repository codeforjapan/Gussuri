import 'package:flutter/material.dart';
import 'package:gussuri/Whale.dart';

class Aquarium extends StatefulWidget {
  const Aquarium({Key? key}) : super(key: key);

  @override
  _AquariumState createState() => _AquariumState();
}

class _AquariumState extends State<Aquarium>
    with TickerProviderStateMixin {
  late AnimationController controller;
  List<Whale> whales = [];

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..forward()
          ..addListener(() {
            if (controller.isCompleted) {
              controller.repeat();
            }
          });
    Future.delayed(const Duration(seconds: 60), () {
      addWhale();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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

  @override
  Widget build(BuildContext context) {

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
            AnimatedBuilder(
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
            ),
            ...whales.map((whale) => AnimatedBuilder(
              animation: whale.controller,
              builder: (context, child) => Transform.translate(
                offset: Offset(200 * shake(whale.controller.value), 0),
                child: child,
              ),
              child: const Image(
                image: AssetImage('images/whale.png'),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ))
          ],
        ))
      ],
    );
  }
}
