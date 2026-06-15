import 'package:flutter/material.dart';

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
    final size = MediaQuery.of(context).size;
    // shortestSide でスケール。縦横回転してもフォントサイズが安定する
    final scale = (size.shortestSide / 360).clamp(1.0, 2.2);
    final hPadding = (size.width * 0.08).clamp(24.0, 120.0);

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
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: size.height * 0.38,
                    maxWidth: size.width * 0.9,
                  ),
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: illustration,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(hPadding, 20, hPadding, 100),
                child: SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0 * scale,
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
                        SizedBox(height: 12.0 * scale),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 15.0 * scale,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
