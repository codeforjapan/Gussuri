import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gussuri/helper/DeviceData.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// ─── Data model ────────────────────────────────────────────────────────────────

class SleepDayRecord {
  final DateTime date;
  final DateTime bedTime;
  final DateTime getUpTime;
  // NOTE: DB field names SOL/TASAFA are semantically swapped in the existing data.
  //   DB 'TASAFA' → sleep onset latency (布団に入ってから眠りにつくまで)
  //   DB 'SOL'    → wake-to-rise time  (目覚めてから布団を出るまで)
  final String sleepOnsetField; // from DB 'TASAFA'
  final String wakeToRiseField; // from DB 'SOL'
  final String wasoField;       // from DB 'WASO'
  final int noa;
  final int dysfunction;

  const SleepDayRecord({
    required this.date,
    required this.bedTime,
    required this.getUpTime,
    required this.sleepOnsetField,
    required this.wakeToRiseField,
    required this.wasoField,
    required this.noa,
    required this.dysfunction,
  });

  int get sleepOnsetMinutes  => _catToMin(sleepOnsetField);
  int get wakeToRiseMinutes  => _catToMin(wakeToRiseField);
  int get wasoMinutes        => _catToMin(wasoField);
  int get timeInBedMinutes   => getUpTime.difference(bedTime).inMinutes;
  int get sleepTimeMinutes   =>
      (timeInBedMinutes - sleepOnsetMinutes - wakeToRiseMinutes - wasoMinutes)
          .clamp(0, 24 * 60);
}

int _catToMin(String? v) => switch (v) {
  '0-15'  => 8,
  '16-30' => 23,
  '31-45' => 38,
  '46-60' => 53,
  '61-'   => 75,
  _       => 0,
};

// ─── Generator ─────────────────────────────────────────────────────────────────

class SleepLogPdfGenerator {
  static const _rowsPerPage = 14;

  // Layout (A4 portrait, 20pt margins → availableWidth ≈ 555pt)
  static const double _dateColW    = 50.0;
  static const double _summaryColW = 72.0;
  static const double _headerH     = 11.0;
  static const double _dataH       = 26.0;
  static const double _secondaryH  = 13.0;

  // Palette (mimics the blue NCNP sheet)
  static final _colDarkNavy   = PdfColor.fromHex('#2C3E6E');
  static final _colLightBlue  = PdfColor.fromHex('#C8DCEA');
  static final _colBedFill    = PdfColor.fromHex('#8BA3C8');
  static final _colSleepFill  = PdfColor.fromHex('#1E3A6E');
  static final _colMarker     = PdfColor.fromHex('#E91E8C');

  // ─── Public entry point ────────────────────────────────────────────────────

  static Future<File> generateAndSave({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    debugPrint('[PDF] step1: fetching records');
    final records = await _fetchRecords(startDate, endDate);
    debugPrint('[PDF] step2: ${records.length} records fetched. loading font');
    final font    = await _loadFont();
    debugPrint('[PDF] step3: font loaded. building document');
    final pdf     = pw.Document();

    // Split into pages of _rowsPerPage
    final pages = <List<SleepDayRecord>>[];
    for (var i = 0; i < records.length; i += _rowsPerPage) {
      pages.add(records.sublist(i, (i + _rowsPerPage).clamp(0, records.length)));
    }
    if (pages.isEmpty) pages.add([]);

    for (var i = 0; i < pages.length; i++) {
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (ctx) => _buildPage(
          ctx, pages[i], font,
          isFirst: i == 0,
          startDate: startDate,
          endDate: endDate,
        ),
      ));
    }

    debugPrint('[PDF] step4: pages built. saving');
    final dir      = await getTemporaryDirectory();
    final fileName =
        'sleep_log_${DateFormat('yyyyMMdd').format(startDate)}-${DateFormat('yyyyMMdd').format(endDate)}.pdf';
    final file = File('${dir.path}/$fileName');
    final bytes = await pdf.save();
    debugPrint('[PDF] step5: bytes=${bytes.length}. writing file');
    await file.writeAsBytes(bytes);
    debugPrint('[PDF] step6: done. path=${file.path}');
    return file;
  }

  // ─── Firestore fetch ────────────────────────────────────────────────────────

  static Future<List<SleepDayRecord>> _fetchRecords(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final deviceId = await DeviceData.getDeviceUniqueId();
    final records  = <SleepDayRecord>[];

    for (var date = startDate;
        !date.isAfter(endDate);
        date = date.add(const Duration(days: 1))) {
      final snap = await FirebaseFirestore.instance
          .collection(deviceId)
          .doc(date.year.toString())
          .collection(date.month.toString().padLeft(2, '0'))
          .doc(date.day.toString().padLeft(2, '0'))
          .get();

      if (!snap.exists) continue;
      final d = snap.data()!;

      DateTime parseTs(dynamic v) =>
          v is Timestamp ? v.toDate().toLocal() : DateTime.parse(v.toString());

      records.add(SleepDayRecord(
        date:             date,
        bedTime:          parseTs(d['bed_time']),
        getUpTime:        parseTs(d['get_up_time']),
        sleepOnsetField:  (d['TASAFA'] ?? '') as String,
        wakeToRiseField:  (d['SOL']    ?? '') as String,
        wasoField:        (d['WASO']   ?? '') as String,
        noa:              (d['NOA']    as int?) ?? 0,
        dysfunction:      (d['dysfunction'] as int?) ?? 0,
      ));
    }

    return records;
  }

  // ─── Page layout ────────────────────────────────────────────────────────────

  static pw.Widget _buildPage(
    pw.Context ctx,
    List<SleepDayRecord> records,
    pw.Font font, {
    required bool isFirst,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final gridW = ctx.page.pageFormat.availableWidth - _dateColW - _summaryColW;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (isFirst) ...[
          _buildTitle(font, startDate, endDate),
          pw.SizedBox(height: 8),
        ],
        ...records.map((r) => _buildDayBlock(r, font, gridW)),
      ],
    );
  }

  static pw.Widget _buildTitle(
    pw.Font font,
    DateTime start,
    DateTime end,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('SELF MONITORING',
            style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey600)),
        pw.Text('睡眠記録シート',
            style: pw.TextStyle(font: font, fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Text(
          '${DateFormat('yyyy年M月d日').format(start)}  〜  ${DateFormat('yyyy年M月d日').format(end)}',
          style: pw.TextStyle(font: font, fontSize: 9),
        ),
      ],
    );
  }

  static pw.Widget _buildDayBlock(SleepDayRecord r, pw.Font font, double gridW) {
    return pw.Column(children: [
      _buildAxisRow(font, gridW),
      _buildDataRow(r, font, gridW),
      _buildSubRow(r, font, gridW),
    ]);
  }

  // Time axis header (dark navy, 15→24→1→14→15)
  static pw.Widget _buildAxisRow(pw.Font font, double gridW) {
    const hours = [15,16,17,18,19,20,21,22,23,24,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
    return pw.Container(
      height: _headerH,
      color: _colDarkNavy,
      child: pw.Row(children: [
        pw.SizedBox(width: _dateColW),
        pw.SizedBox(
          width: gridW,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: hours
                .map((h) => pw.Text('$h',
                    style: pw.TextStyle(font: font, fontSize: 5.5, color: PdfColors.white)))
                .toList(),
          ),
        ),
        pw.SizedBox(width: _summaryColW),
      ]),
    );
  }

  // Main data row: date + sleep grid + sleep time
  static pw.Widget _buildDataRow(SleepDayRecord r, pw.Font font, double gridW) {
    final bedX        = _timeToX(r.bedTime, gridW);
    final getUpX      = _timeToX(r.getUpTime, gridW);
    final sleepStartX = (bedX   + r.sleepOnsetMinutes  / (24 * 60) * gridW).clamp(0.0, gridW);
    final sleepEndX   = (getUpX - r.wakeToRiseMinutes  / (24 * 60) * gridW).clamp(0.0, gridW);
    final sleepLabel  = _fmtDuration(r.sleepTimeMinutes);

    return pw.Container(
      height: _dataH,
      color: _colLightBlue,
      child: pw.Row(children: [
        // Date
        pw.Container(
          width: _dateColW,
          alignment: pw.Alignment.center,
          child: pw.Text(
            '${DateFormat('M/d').format(r.date)}\n(${_weekday(r.date)})',
            style: pw.TextStyle(font: font, fontSize: 7),
            textAlign: pw.TextAlign.center,
          ),
        ),
        // Sleep band grid
        pw.SizedBox(
          width: gridW,
          height: _dataH,
          child: pw.CustomPaint(
            size: PdfPoint(gridW, _dataH),
            painter: (canvas, size) => _paintBand(
              canvas, size,
              bedX: bedX, getUpX: getUpX,
              sleepStartX: sleepStartX, sleepEndX: sleepEndX,
            ),
          ),
        ),
        // Sleep time
        pw.Container(
          width: _summaryColW,
          alignment: pw.Alignment.centerRight,
          padding: const pw.EdgeInsets.only(right: 4),
          child: pw.Text('睡眠 $sleepLabel',
              style: pw.TextStyle(font: font, fontSize: 6.5)),
        ),
      ]),
    );
  }

  // Secondary row: WASO info + time-in-bed
  static pw.Widget _buildSubRow(SleepDayRecord r, pw.Font font, double gridW) {
    final inBedLabel = _fmtDuration(r.timeInBedMinutes);
    final wasoText   = r.wasoField.isNotEmpty ? r.wasoField : '-';

    return pw.Container(
      height: _secondaryH,
      child: pw.Row(children: [
        pw.SizedBox(width: _dateColW),
        pw.Expanded(
          child: pw.Container(
            color: PdfColors.white,
            padding: const pw.EdgeInsets.symmetric(horizontal: 4),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              '中途覚醒: ${r.noa}回  合計: $wasoText分',
              style: pw.TextStyle(font: font, fontSize: 6, color: PdfColors.grey700),
            ),
          ),
        ),
        pw.Container(
          width: _summaryColW,
          color: PdfColors.white,
          alignment: pw.Alignment.centerRight,
          padding: const pw.EdgeInsets.only(right: 4),
          child: pw.Text('布団 $inBedLabel',
              style: pw.TextStyle(font: font, fontSize: 6.5)),
        ),
      ]),
    );
  }

  // ─── Custom paint: sleep band ───────────────────────────────────────────────

  static void _paintBand(
    PdfGraphics g,
    PdfPoint size, {
    required double bedX,
    required double getUpX,
    required double sleepStartX,
    required double sleepEndX,
  }) {
    final w = size.x;
    final h = size.y;

    // 1. Bed area (light blue fill)
    if (getUpX > bedX) {
      g.setFillColor(_colBedFill);
      g.drawRect(bedX, 1, getUpX - bedX, h - 2);
      g.fillPath();
    }

    // 2. Sleep band: dark fill + diagonal hatching
    final sx = sleepStartX.clamp(0.0, w);
    final ex = sleepEndX.clamp(0.0, w);
    if (ex > sx) {
      final sw = ex - sx;
      g.setFillColor(_colSleepFill);
      g.drawRect(sx, 1, sw, h - 2);
      g.fillPath();

      g.setStrokeColor(PdfColors.white);
      g.setLineWidth(0.5);
      const spacing = 4.0;
      final bandH = h - 2;
      for (var d = -bandH; d <= sw; d += spacing) {
        final seg = _clipLine(
          sx + d, 1.0, sx + d + bandH, h - 1.0,
          sx, 1.0, sx + sw, h - 1.0,
        );
        if (seg != null) {
          g.moveTo(seg[0], seg[1]);
          g.lineTo(seg[2], seg[3]);
          g.strokePath();
        }
      }
    }

    // 3. Hourly vertical grid lines
    g.setStrokeColor(PdfColors.grey);
    g.setLineWidth(0.2);
    for (var i = 1; i < 24; i++) {
      final x = i / 24.0 * w;
      g.moveTo(x, 0);
      g.lineTo(x, h);
      g.strokePath();
    }

    // 4. Bed-time / get-up-time markers
    g.setFillColor(_colMarker);
    if (bedX >= 0 && bedX <= w) {
      g.drawEllipse(bedX, h / 2, 2.5, 2.5);
      g.fillPath();
    }
    if (getUpX >= 0 && getUpX <= w) {
      g.drawEllipse(getUpX, h / 2, 2.5, 2.5);
      g.fillPath();
    }
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  // Convert a DateTime to x-position on the 15:00-based 24h axis.
  static double _timeToX(DateTime t, double gridW) {
    final mins = ((t.hour - 15 + 24) % 24) * 60 + t.minute;
    return mins / (24 * 60) * gridW;
  }

  // Liang-Barsky line clipping to axis-aligned rectangle.
  static List<double>? _clipLine(
    double x1, double y1, double x2, double y2,
    double xMin, double yMin, double xMax, double yMax,
  ) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    double t0 = 0, t1 = 1;
    final p = [-dx, dx, -dy, dy];
    final q = [x1 - xMin, xMax - x1, y1 - yMin, yMax - y1];
    for (var i = 0; i < 4; i++) {
      if (p[i] == 0) {
        if (q[i] < 0) return null;
      } else {
        final t = q[i] / p[i];
        if (p[i] < 0) {
          if (t > t0) t0 = t;
        } else {
          if (t < t1) t1 = t;
        }
      }
    }
    if (t0 > t1) return null;
    return [x1 + t0 * dx, y1 + t0 * dy, x1 + t1 * dx, y1 + t1 * dy];
  }

  static String _fmtDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '$h時間$m分';
  }

  static String _weekday(DateTime d) =>
      const ['月', '火', '水', '木', '金', '土', '日'][d.weekday - 1];

  static Future<pw.Font> _loadFont() async {
    final data = await rootBundle.load('assets/NotoSansJP-VariableFont_wght.ttf');
    return pw.Font.ttf(data.buffer.asByteData());
  }
}
