import 'package:casetracking/features/reports/models/received_report_model.dart';
import 'package:flutter/material.dart';

class ReceivedReportDetailScreen extends StatelessWidget {
  final ReceivedReportModel report;

  const ReceivedReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(report.barcode ?? "Barcode")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _info("Box Size", report.boxSize ?? "-"),
            _info(
              "Received",
              "${report.receivedDate ?? "-"} • ${report.receivedTime ?? "-"}",
            ),
            _info("Location", report.receivedLocation ?? "-"),
            _info("Received By", report.receivedBy ?? "-"),
            _info(
              "Status",
              report.stillAssigned == 1 ? "Still Assigned" : "Received",
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
