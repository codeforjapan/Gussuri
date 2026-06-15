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
  // ignore: unused_field
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

      // 月単位でまとめて並列取得
      final monthKeys = <String, (String, String)>{};
      for (DateTime date = startDate;
          !date.isAfter(endDate);
          date = date.add(const Duration(days: 1))) {
        final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        monthKeys[key] = (date.year.toString(), date.month.toString().padLeft(2, '0'));
      }
      final monthList = monthKeys.values.toList();
      final snaps = await Future.wait(
        monthList.map((ym) => FirebaseFirestore.instance
            .collection(deviceUniqueId)
            .doc(ym.$1)
            .collection(ym.$2)
            .get()),
      );

      for (var i = 0; i < snaps.length; i++) {
        final (yearStr, monthStr) = monthList[i];
        final year = int.parse(yearStr);
        final month = int.parse(monthStr);
        for (final doc in snaps[i].docs) {
          final day = int.tryParse(doc.id);
          if (day == null) continue;
          final date = DateTime(year, month, day);
          if (date.isBefore(startDate) || date.isAfter(endDate)) continue;
          final data = doc.data();
          rows.add([
            DateFormat('yyyy-MM-dd').format(date),
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
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
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
            // TODO: PDF export button — re-enable once PDF format is finalized
            // Padding(
            //   padding: EdgeInsets.only(top: 12.h),
            //   child: ElevatedButton(
            //     key: _pdfButtonKey,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: isGeneratingPdf ? Colors.grey : Colors.blueAccent,
            //       foregroundColor: Colors.white,
            //       minimumSize: Size(280.w, 50.h),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(50),
            //       ),
            //     ),
            //     onPressed: isGeneratingPdf
            //         ? null
            //         : () => savePDF(
            //               localizations.csvGenerationFailed,
            //               shareOrigin: _buttonRect(_pdfButtonKey),
            //             ),
            //     child: Text(
            //       localizations.printExportPdf,
            //       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // )
          ],
        )
      ],
            ),
          ),
        ),
    );
  }
}
