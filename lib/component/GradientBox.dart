import 'package:flutter/cupertino.dart';

class GradientBox extends StatelessWidget {
  final Widget child;

  const GradientBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xffffefc7),
                Color(0xffa4e9ff),
                Color(0xff6cb9ff),
                Color(0xff180077),
                Color(0xff001637),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
      child: child,
    );
  }
}