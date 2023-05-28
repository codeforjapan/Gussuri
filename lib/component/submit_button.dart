import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  const SubmitButton({super.key, required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(150.w, 60.h),
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
