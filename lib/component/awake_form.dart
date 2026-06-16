import 'package:flutter/material.dart';
import 'package:gussuri/component/image_buttons.dart';
import '../gen_l10n/app_localizations.dart';

class AwakeForm extends StatefulWidget {
  final ValueChanged<int?>? onChangedTimes;
  final ValueChanged<String?>? onChangedSlide;
  final String? slideValue;
  final int? timesValue;

  const AwakeForm(
      {super.key,
      this.onChangedTimes,
      this.onChangedSlide,
      this.slideValue,
      this.timesValue});

  @override
  AwakeFormState createState() => AwakeFormState();
}

class AwakeFormState extends State<AwakeForm> with TickerProviderStateMixin {
  List<bool> isSelected = List.generate(11, (i) => false);
  bool isChecked = false;
  late final Function(int?) submitOnChangedTimes;
  late final Function(String?) submitOnChangedSlide;

  @override
  void initState() {
    super.initState();
    if (widget.onChangedTimes != null) {
      submitOnChangedTimes = widget.onChangedTimes!;
    }
    if (widget.onChangedSlide != null) {
      submitOnChangedSlide = widget.onChangedSlide!;
    }
    if (widget.timesValue != null) {
      final int times = widget.timesValue!;
      isSelected[times] = true;
      if (times > 0) {
        isChecked = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size.shortestSide;
    final w = (20.0 * ss / 360).clamp(20.0, 24.0);
    final h = (20.0 * ss / 360).clamp(20.0, 24.0);
    final innerW = (10.0 * ss / 360).clamp(10.0, 12.0);
    final listH = (40.0 * ss / 360).clamp(40.0, 48.0);
    final sepW = (5.0 * ss / 360).clamp(5.0, 6.0);
    return Card(
        margin: EdgeInsets.only(top: h / 2, right: w, left: w),
        color: Colors.white.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: h),
            child: Text(
              AppLocalizations.of(context)?.inputAwakeingAfter ?? '途中で目が覚めた',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: innerW, left: innerW, bottom: h / 4),
            child: SizedBox(
              height: listH,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: isSelected.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSelected = List.generate(11, (index) => false);
                        isSelected[index] = true;
                        if (index == 0) {
                          submitOnChangedSlide('0');
                          isChecked = false;
                        } else {
                          isChecked = true;
                        }
                        submitOnChangedTimes(index);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                            width: 5.0,
                            color: isSelected[index]
                                ? const Color(0xFF00475C)
                                : const Color(0xFFEFEFEF))),
                    child: Text('$index'),
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(padding: EdgeInsets.all(sepW));
                },
              ),
            ),
          ),
          Visibility(
            visible: isChecked,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: h),
                child: Opacity(
                  opacity: isChecked ? 1 : 0.5,
                  child: Text(
                    AppLocalizations.of(context)?.inputAwakeingAfterAverageTime ?? '複数回の場合は平均を教えてください',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Visibility(
              visible: isChecked,
              child: ImageButton(
                  value: widget.slideValue,
                  onChanged: (value) {
                    setState(() {
                      submitOnChangedSlide(value);
                    });
                  }))
        ]));
  }
}
