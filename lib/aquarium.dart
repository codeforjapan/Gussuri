import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gussuri/calendar.dart';
import 'package:gussuri/helper/DateKey.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/recording.dart';
import './questionnaire.dart';
import 'dart:math' as math;

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return 64 * math.sin(2 * math.pi * t);
  }
}

class Aquarium extends StatefulWidget {
  const Aquarium({Key? key}) : super(key: key);

  @override
  _AquariumState createState() => _AquariumState();
}

class _AquariumState extends State<Aquarium>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      fit: StackFit.expand,
      children: const [
        AnimatedPositioned(
          child: Image(
            image: AssetImage('images/fish.gif'),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          duration: Duration(seconds: 2),
          left: 100,
          top: 100,
          // top:100 * sin(2*ref.watch(animationParamaterPr
        )
      ],
    );
  }
}
