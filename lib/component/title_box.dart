import 'package:flutter/material.dart';
import 'package:gussuri/utils.dart';

class TitleBox extends StatelessWidget {
  final String text;
  const TitleBox({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    if (isTablet(context)) return const SizedBox.shrink();
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF002153)),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
