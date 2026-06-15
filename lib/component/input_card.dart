import 'package:flutter/material.dart';

class InputCard extends StatelessWidget {
  const InputCard({super.key, required this.form, required this.title});
  final String title;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size.shortestSide;
    final h = (20.0 * ss / 360).clamp(20.0, 24.0);
    final w = (20.0 * ss / 360).clamp(20.0, 24.0);
    return Card(
        margin: EdgeInsets.only(top: h / 2, right: w, left: w),
        color: Colors.white.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: h),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          form
        ]));
  }
}
