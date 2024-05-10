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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Future saveCSV(String completeMsg, String failMsg) async {
    setState(() {
      isGeneratingCsv = true;
    });
    try {
    String deviceUniqueId = await DeviceData.getDeviceUniqueId();

    List<List<dynamic>> rows = [];
    rows.add(['date', 'bed_time', 'TASAFA', 'get_up_time', 'dysfunction', 'WASO', 'SOL', 'NOA']);

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
        List<dynamic> row = [
          DateFormat('yyyy-MM-dd').format(DateTime.parse(parseFormat(data['bed_time']))),
          DateFormat('HH:mm').format(DateTime.parse(parseFormat(data['bed_time']))),
          data['TASAFA'],
          DateFormat('HH:mm').format(DateTime.parse(parseFormat(data['get_up_time']))),
          data['dysfunction'],
          data['WASO'],
          data['SOL'],
          data['NOA'],
        ];
        rows.add(row);
      }
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/sleep_record_${DateFormat('yyyy-MM-dd-Hm').format(DateTime.now())}.csv');
    await file.writeAsString(csvData);

    Fluttertoast.showToast(
      msg: completeMsg,
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    } catch (e) {
      Fluttertoast.showToast(
        msg: failMsg,
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

  String parseFormat(dynamic date) {
    if(date is Timestamp) {
      return date.toDate().toLocal().toString();
    } else {
      return date.toString();
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
        DateFormat('yyyy/MM/dd').format(selectedDate),
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
        body: Column(
      children: [
        TitleBox(text: localizations.printSleepLog),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, top: 10.h),
            child: Text(
              localizations.printDuration,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                onPressed: isGeneratingCsv ? null : () => saveCSV(localizations.csvDownloadCompleted, localizations.csvGenerationFailed),
                child: Text(
                  localizations.printPrintData,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}
