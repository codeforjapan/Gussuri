import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  const SubmitButton({super.key, required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size.shortestSide;
    final pad = (20.0 * ss / 360).clamp(20.0, 24.0);
    final minW = (150.0 * ss / 360).clamp(150.0, 200.0);
    final minH = (60.0 * ss / 360).clamp(60.0, 70.0);
    return Padding(
      padding: EdgeInsets.only(right: pad, top: pad, bottom: pad / 2),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(minW, minH),
            backgroundColor: const Color(0xFFFFD069),
            foregroundColor: Colors.black,
            disabledForegroundColor: const Color(0xFF101326),
            disabledBackgroundColor: const Color(0xFF6D5F44),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(50),
            )),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )),
    );
  }
}
