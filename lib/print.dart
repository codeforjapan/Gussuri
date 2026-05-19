import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gussuri/component/title_box.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:gussuri/pdf_utils.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'gen_l10n/app_localizations.dart';

class Print extends StatefulWidget {
  const Print({super.key});

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  late DateTime startDate;
  late DateTime endDate;
  bool isGeneratingCsv = false;
  bool isGeneratingPdf = false;
  final _csvButtonKey = GlobalKey();
  final _pdfButtonKey = GlobalKey();

  Rect _buttonRect(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return Rect.zero;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  void initState() {
    super.initState();
    var today = DateTime.now();
    startDate = DateTime(today.year, today.month - 1, today.day);
    endDate = today;
  }

  Future<void> saveCSV(String failMsg, {required Rect shareOrigin}) async {
    setState(() => isGeneratingCsv = true);
    try {
      final deviceUniqueId = await DeviceData.getDeviceUniqueId();

      final rows = <List<dynamic>>[
        ['date', 'bed_time', 'TASAFA', 'get_up_time', 'dysfunction', 'WASO', 'SOL', 'NOA'],
      ];

      for (DateTime date = startDate;
          date.isBefore(endDate.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))) {
        final year = date.year.toString();
        final month = date.month.toString().padLeft(2, '0');
        final day = date.day.toString().padLeft(2, '0');

        final snap = await FirebaseFirestore.instance
            .collection(deviceUniqueId)
            .doc(year)
            .collection(month)
            .doc(day)
            .get();

        if (snap.exists) {
          final data = snap.data()!;
          rows.add([
            DateFormat('yyyy-MM-dd').format(DateTime.parse(parseFormat(data['bed_time']))),
            DateFormat('HH:mm').format(DateTime.parse(parseFormat(data['bed_time']))),
            data['TASAFA'],
            DateFormat('HH:mm').format(DateTime.parse(parseFormat(data['get_up_time']))),
            data['dysfunction'],
            data['WASO'],
            data['SOL'],
            data['NOA'],
          ]);
        }
      }

      final csvData = const ListToCsvConverter().convert(rows);
      final dir = await getTemporaryDirectory();
      final fileName = 'sleep_record_${DateFormat('yyyyMMdd').format(startDate)}-${DateFormat('yyyyMMdd').format(endDate)}.csv';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(csvData);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        fileNameOverrides: [fileName],
        sharePositionOrigin: shareOrigin,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failMsg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isGeneratingCsv = false);
    }
  }

  Future<void> savePDF(String failMsg, {required Rect shareOrigin}) async {
    setState(() => isGeneratingPdf = true);
    try {
      final file = await SleepLogPdfGenerator.generateAndSave(
        startDate: startDate,
        endDate: endDate,
      );
      final fileName =
          'sleep_log_${DateFormat('yyyyMMdd').format(startDate)}-${DateFormat('yyyyMMdd').format(endDate)}.pdf';
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        fileNameOverrides: [fileName],
        sharePositionOrigin: shareOrigin,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failMsg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isGeneratingPdf = false);
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
                key: _csvButtonKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGeneratingCsv ? Colors.grey : Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: Size(280.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: isGeneratingCsv
                    ? null
                    : () => saveCSV(
                          localizations.csvGenerationFailed,
                          shareOrigin: _buttonRect(_csvButtonKey),
                        ),
                child: Text(
                  localizations.printPrintData,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: ElevatedButton(
                key: _pdfButtonKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGeneratingPdf ? Colors.grey : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(280.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: isGeneratingPdf
                    ? null
                    : () => savePDF(
                          localizations.csvGenerationFailed,
                          shareOrigin: _buttonRect(_pdfButtonKey),
                        ),
                child: Text(
                  localizations.printExportPdf,
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
