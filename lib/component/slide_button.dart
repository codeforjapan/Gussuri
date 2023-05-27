import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/component/input_card.dart';

class SlideButton extends StatefulWidget {
  final ValueChanged<int?>? onChanged;

  const SlideButton({super.key, this.onChanged});

  @override
  SlideButtonState createState() => SlideButtonState();
}

class SlideButtonState extends State<SlideButton>
    with TickerProviderStateMixin {
  List<bool> isSelected = List.generate(11, (i) => false);
  late final Function(int?) submitOnChanged;

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 140.w);

  @override
  void initState() {
    super.initState();
    isSelected[4] = true;
    if (widget.onChanged != null) {
      submitOnChanged = widget.onChanged!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputCard(
      title: '前日夜から当日朝の睡眠で\n休養は取れましたか？',
      form: SizedBox(
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
                        isSelected = List.generate(11, (index) => false);
                        isSelected[index] = true;
                        submitOnChanged(index);
                      });
                    },
                    style:
                        ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white
                        ),
                    child: ClipOval(
                        child: Opacity(
                          opacity: isSelected[index] ? 1 : 0.5,
                          child: Image.asset('images/evaluation_$index.jpg'),
                        )
                    ),
                  ),
                  Text(
                    '評価${index + 1}',
                    style: TextStyle(
                        color: isSelected[index]
                            ? Colors.black.withOpacity(1)
                            : Colors.black.withOpacity(0.4)),
                  )
                ],
              );
            }),
      ),
    );
  }
}
