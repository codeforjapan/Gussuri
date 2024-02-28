import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Print extends StatefulWidget {
  const Print({super.key});

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  late DateTime startDate;
  late DateTime endDate;
  bool isGeneratingCsv = false;

  @override
  void initState() {
    super.initState();
    var today = DateTime.now();
    startDate = DateTime(today.year, today.month - 1, today.day);
    endDate = today;
  }

  Future saveCSV() async {
    setState(() {
      isGeneratingCsv = true;
    });
    try {
    String deviceUniqueId = await DeviceData.getDeviceUniqueId();

    List<List<dynamic>> rows = [];
    rows.add(['bed_time', 'TASAFA', 'get_up_time', 'dysfunction', 'WASO', 'SOL', 'NOA']);

    for (DateTime date = startDate;
    date.isBefore(endDate.add(const Duration(days: 1)));
    date = date.add(const Duration(days: 1))) {
      String year = date.year.toString();
      String month = date.month.toString().padLeft(2, '0');
      String day = date.day.toString().padLeft(2, '0');

      var daySnapshot = await FirebaseFirestore.instance
          .collection(deviceUniqueId)
          .doc(year)
          .collection(month)
          .doc(day)
          .get();

      if (daySnapshot.exists) {
        var data = daySnapshot.data() as Map<String, dynamic>;
        rows.add(data.values.map((e) {
          if(e is Timestamp) {
            return e.toDate().toLocal().toString();
          } else {
            return e.toString();
          }
        }).toList());
      }
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/sleep_record_${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}.csv');
    await file.writeAsString(csvData);

    Fluttertoast.showToast(
      msg: 'CSVのダウンロードが完了しました',
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'CSVの生成に失敗しました。しばらく時間をおいて再度お試しください。',
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        isGeneratingCsv = false;
      });
    }
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
          firstDate: DateTime(2010),
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
                  backgroundColor: isGeneratingCsv ? Colors.grey : Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: Size(280.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: isGeneratingCsv ? null : saveCSV,
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
