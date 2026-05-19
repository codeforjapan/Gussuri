import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/component/input_card.dart';
import '../gen_l10n/app_localizations.dart';

class SlideButton extends StatefulWidget {
  final ValueChanged<int?>? onChanged;
  final int value;

  const SlideButton({super.key, this.onChanged, required this.value});

  @override
  SlideButtonState createState() => SlideButtonState();
}

class SlideButtonState extends State<SlideButton>
    with TickerProviderStateMixin {
  List<bool> isSelected = List.generate(11, (_) => false);
  late final Function(int?) submitOnChanged;
  final ScrollController _scrollController = ScrollController();

  // Must match itemExtent on the ListView
  static double get _itemW => 56.w;

  @override
  void initState() {
    super.initState();
    submitOnChanged = widget.onChanged ?? (_) {};
    final idx = 10 - widget.value;
    isSelected[idx] = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpTo(idx));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _jumpTo(int index) {
    if (!mounted || !_scrollController.hasClients) return;
    final target = (index * _itemW)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.jumpTo(target);
  }

  void scrollLeft() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      (_scrollController.offset - _itemW)
          .clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      (_scrollController.offset + _itemW)
          .clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return InputCard(
      title: localizations.inputLastnight,
      form: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left, size: 32),
            onPressed: scrollLeft,
          ),
          Expanded(
            child: SizedBox(
              height: 70.h,
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemExtent: _itemW,
                itemCount: isSelected.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSelected.fillRange(0, isSelected.length, false);
                            isSelected[index] = true;
                          });
                          submitOnChanged(10 - index);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) _jumpTo(index);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          fixedSize: Size(44.w, 44.w),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: ClipOval(
                          child: Opacity(
                            opacity: isSelected[index] ? 1 : 0.5,
                            child: Image.asset(
                                'images/evaluation_${10 - index}.jpg'),
                          ),
                        ),
                      ),
                      Text(
                        '${localizations.rate} $index',
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected[index]
                              ? Colors.black
                              : Colors.black.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right, size: 32),
            onPressed: scrollRight,
          ),
        ],
      ),
    );
  }
}
