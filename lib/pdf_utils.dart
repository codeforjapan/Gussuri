import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;



class PdfGenerator {
  static Future<pw.Document> generatePdfDocument() async {

    final fontData = await rootBundle.load("assets/NotoSansJP-VariableFont_wght.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // todo Create format
    pw.Widget _buildRow(String label, String value) {
      return pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 5),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 16,
                // fontWeight: pw.FontWeight.bold,
                font: ttf
              ),
            ),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 16,
                font: ttf
              ),
            ),
          ],
        ),
      );
    }

    final pdf = pw.Document();


    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Padding(
            padding: pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '睡眠記録シート',
                  style: pw.TextStyle(
                    fontSize: 30,
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                _buildRow('日付', '2023年06月10日'),
                _buildRow('就寝時間', '23:00'),
                _buildRow('起床時間', '07:00'),
                _buildRow('睡眠時間', '8時間'),
                _buildRow('睡眠効果', '★★★★'),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf;
  }
}