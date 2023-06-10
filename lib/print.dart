import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:intl/intl.dart';

class Print extends StatefulWidget {
  const Print({super.key});

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  late DateTime startDate; // 型推論を避けるためにlate修飾子を追加
  late DateTime endDate; // 型推論を避けるためにlate修飾子を追加

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().subtract(const Duration(days: 1));
    endDate = DateTime.now();
  }

  Widget datePickerButton({
    required DateTime selectedDate,
    required void Function(DateTime) onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(280.w, 60.h),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(
          width: 5.0,
          color: Color(0xFFEBEBEB),
        ),
      ),
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: startDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          onPressed(selectedDate); // コールバック関数で選択された日付を親ウィジェットに通知
        }
      },
      child: Text(
        DateFormat('yyyy年MM月dd日').format(selectedDate),
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const TitleBox(text: '睡眠記録の印刷'),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, top: 10.h),
            child: const Text(
              '印刷期間',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: datePickerButton(
                  selectedDate: startDate,
                  onPressed: (selectedDate) {
                    setState(() {
                      startDate = selectedDate;
                    });
                  },
                )),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 40,
            ),
            datePickerButton(
              selectedDate: endDate,
              onPressed: (selectedDate) {
                setState(() {
                  endDate = selectedDate;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: Size(280.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  print('push print');
                },
                child: const Text(
                  '印刷フォーマットに書き出し',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}
