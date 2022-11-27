import 'package:flutter/material.dart';
import 'package:gussuri/component/Fish.dart';

class Aquarium extends StatefulWidget {
  const Aquarium({Key? key}) : super(key: key);

  @override
  _AquariumState createState() => _AquariumState();
}

class _AquariumState extends State<Aquarium> {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
              color: Colors.black,
                image: DecorationImage(
                    image: AssetImage('images/background.jpg'), fit: BoxFit.cover)),
        ),
        Fish(),
      ],
    );
  }
}
