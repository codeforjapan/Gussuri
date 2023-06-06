import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:gussuri/component/image_buttons.dart';

class AwakeForm extends StatefulWidget {
  final ValueChanged<int?>? onChangedTimes;
  final ValueChanged<String?>? onChangedSlide;

  const AwakeForm({super.key, this.onChangedTimes, this.onChangedSlide});

  @override
  AwakeFormState createState() => AwakeFormState();
}

class AwakeFormState extends State<AwakeForm> with TickerProviderStateMixin {
  List<bool> isSelected = List.generate(10, (i) => false);
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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(top: 10.h, right: 20.w, left: 20.w),
        color: Colors.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Text(
              '途中で目が覚めた',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 5.h),
            child: SizedBox(
              height: 40.h,
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
                        color: isSelected[index] ? const Color(0xFF00475C) :const Color(0xFFEFEFEF)
                      )
                    ),
                    child: Text('$index'),
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(padding: EdgeInsets.all(5.w));
                },
              ),
            ),
          ),
          Visibility(
            visible: isChecked,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Opacity(
                  opacity: isChecked ? 1 : 0.5,
                  child: const Text(
                    '複数回の場合は平均を教えてください',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Visibility(
              visible: isChecked,
              child: ImageButton(onChanged: (value) {
                setState(() {
                  submitOnChangedSlide(value);
                });
              }))
        ]));
  }
}
