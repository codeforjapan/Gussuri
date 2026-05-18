import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/component/input_card.dart';
import 'gen_l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    submitOnChanged = widget.onChanged ?? (_) {};

    int reversedIndex = 10 - widget.value;
    isSelected[reversedIndex] = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo((reversedIndex * 40).w);
    });
  }

  void scrollToIndex(int index) {
    double position = index * 40.w;
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollLeft() {
    double newOffset = (_scrollController.offset - 40.w).clamp(0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    double newOffset = (_scrollController.offset + 40.w).clamp(0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      newOffset,
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
                itemCount: isSelected.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSelected.fillRange(0, isSelected.length, false);
                            isSelected[index] = true;
                            submitOnChanged(10 - index);
                            scrollToIndex(index);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white),
                        child: ClipOval(
                          child: Opacity(
                            opacity: isSelected[index] ? 1 : 0.5,
                            child: Image.asset('images/evaluation_${10 - index}.jpg'),
                          ),
                        ),
                      ),
                      Text(
                        '${localizations.rate} $index',
                        style: TextStyle(
                            color: isSelected[index]
                                ? Colors.black
                                : Colors.black.withOpacity(0.4)),
                      )
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
