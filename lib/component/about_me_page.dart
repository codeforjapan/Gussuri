import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutMePage extends StatelessWidget {
  final String title;
  final String description;
  final Widget illustration;
  final List<Color> gradientColors;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const AboutMePage({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    required this.gradientColors,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: screenHeight * 0.28,
                            ),
                            child: illustration,
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14.sp,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ボタンバーの高さ分の余白を確保
                  const SizedBox(height: 96),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
