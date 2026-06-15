import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/base.dart';
import 'package:gussuri/component/about_me_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gen_l10n/app_localizations.dart';

class AboutMe extends StatefulWidget {
  final bool isOnboarding;
  const AboutMe({super.key, this.isOnboarding = false});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  static final _staticFade = kAlwaysCompleteAnimation;
  static final _staticSlide = const AlwaysStoppedAnimation<Offset>(Offset.zero);
  int _currentPage = 0;

  static const int _totalPages = 8;

  static const List<List<Color>> _gradients = [
    [Color(0xFFFFF0C7), Color(0xFFFFE4A3)],
    [Color(0xFFFFEAA0), Color(0xFFB8E8FF)],
    [Color(0xFF9EDFFF), Color(0xFF64C8FF)],
    [Color(0xFF64C8FF), Color(0xFF2699E8)],
    [Color(0xFF2699E8), Color(0xFF0D5DB5)],
    [Color(0xFF0D5DB5), Color(0xFF002F7A)],
    [Color(0xFF002F7A), Color(0xFF001637)],
    [Color(0xFF001637), Color(0xFF000A1F)],
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    // 同じAnimationを全ページで共有しているため、ページ切替時に
    // reset+forwardすることで可視ページだけアニメーションが見える
    _animController.reset();
    _animController.forward();
  }

  Future<void> _next() async {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else if (widget.isOnboarding) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Base()),
        );
      }
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isLast = _currentPage == _totalPages - 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _totalPages,
            itemBuilder: (context, index) => _buildPage(l, index),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DotIndicator(
                          total: _totalPages,
                          current: _currentPage,
                          onTap: (i) => _pageController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF002153),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Text(isLast ? l.aboutMeDone : l.aboutMeNext),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(AppLocalizations l, int index) {
    final isActive = index == _currentPage;
    final fade = isActive ? _fadeAnim : _staticFade;
    final slide = isActive ? _slideAnim : _staticSlide;

    switch (index) {
      case 0:
        return AboutMePage(
          title: l.aboutMePage1Title,
          description: l.aboutMePage1Body,
          illustration: Image.asset('images/baku-kun-1.png', height: 200.h),
          gradientColors: _gradients[0],
          fadeAnimation: fade,
          slideAnimation: slide,
        );
      case 1:
        return AboutMePage(
          title: l.aboutMePage2Title,
          description: l.aboutMePage2Body,
          illustration: Image.asset('images/baku-kun-1.png', height: 180.h),
          gradientColors: _gradients[1],
          fadeAnimation: fade,
          slideAnimation: slide,
        );
      case 2:
        return AboutMePage(
          title: l.aboutMePage3Title,
          description: l.aboutMePage3Body,
          illustration: const _EvaluationSample(),
          gradientColors: _gradients[2],
          fadeAnimation: fade,
          slideAnimation: slide,
        );
      case 3:
        return AboutMePage(
          title: l.aboutMePage4Title,
          description: l.aboutMePage4Body,
          illustration: Image.asset('images/baku-kun-2.png', height: 200.h),
          gradientColors: _gradients[3],
          fadeAnimation: fade,
          slideAnimation: slide,
        );
      case 4:
        return AboutMePage(
          title: l.aboutMePage5Title,
          description: l.aboutMePage5Body,
          illustration: const _MoonIllustration(),
          gradientColors: _gradients[4],
          fadeAnimation: fade,
          slideAnimation: slide,
        );
      case 5:
        return AboutMePage(
          title: l.aboutMePage6Title,
          description: l.aboutMePage6Body,
          illustration: const _TimeSample(),
          gradientColors: _gradients[5],
          fadeAnimation: fade,
          slideAnimation: slide,
        );
      case 6:
        return AboutMePage(
          title: l.aboutMePage7Title,
          description: l.aboutMePage7Body,
          illustration: const _CalendarIllustration(),
          gradientColors: _gradients[6],
          fadeAnimation: fade,
          slideAnimation: slide,
        );
      case 7:
      default:
        return AboutMePage(
          title: l.aboutMePage8Title,
          description: l.aboutMePage8Body,
          illustration: const _ExportIllustration(),
          gradientColors: _gradients[7],
          fadeAnimation: fade,
          slideAnimation: slide,
        );
    }
  }
}

class _DotIndicator extends StatelessWidget {
  final int total;
  final int current;
  final ValueChanged<int> onTap;

  const _DotIndicator({
    required this.total,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        return GestureDetector(
          onTap: () => onTap(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: i == current ? 20.0 : 7.0,
            height: 7.0,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: i == current
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
            ),
          ),
        );
      }),
    );
  }
}

class _EvaluationSample extends StatelessWidget {
  const _EvaluationSample();

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final imgSize = (shortestSide / 360 * 54).clamp(54.0, 88.0);
    final hPad = (shortestSide / 360 * 6).clamp(6.0, 10.0);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [0, 3, 5, 7, 10].map((i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'images/evaluation_$i.jpg',
                  width: imgSize,
                  height: imgSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MoonIllustration extends StatelessWidget {
  const _MoonIllustration();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.nightlight_round,
      size: 140.w,
      color: Colors.white.withValues(alpha: 0.9),
    );
  }
}

class _TimeSample extends StatelessWidget {
  const _TimeSample();

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final imgSize = (shortestSide / 360 * 48).clamp(48.0, 80.0);
    final hPad = (shortestSide / 360 * 6).clamp(6.0, 10.0);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Image.asset(
              'images/time$i.png',
              width: imgSize,
              height: imgSize,
            ),
          );
        }),
      ),
    );
  }
}

class _CalendarIllustration extends StatelessWidget {
  const _CalendarIllustration();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.calendar_month,
      size: 130.w,
      color: Colors.white.withValues(alpha: 0.9),
    );
  }
}

class _ExportIllustration extends StatelessWidget {
  const _ExportIllustration();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.file_download_outlined,
      size: 130.w,
      color: Colors.white.withValues(alpha: 0.9),
    );
  }
}
