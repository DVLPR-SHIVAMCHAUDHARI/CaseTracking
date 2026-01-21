import 'package:casetracking/features/reports/models/assigned_model.dart';
import 'package:flutter/material.dart';

class AssignedReportDetailScreen extends StatelessWidget {
  final AssignedBatch batch;

  const AssignedReportDetailScreen({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Batch #${batch.id}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Batch Info"),
            _infoTile("Location", batch.locationName),
            _infoTile("Assigned By", batch.createdBy),
            _infoTile(
              "Box Size",
              "${batch.boxSize.length}×${batch.boxSize.width}×${batch.boxSize.height}",
            ),
            _infoTile("Date", "${batch.date} • ${batch.time}"),

            const SizedBox(height: 20),
            _sectionTitle("Barcodes (${batch.barcodes.length})"),

            ...batch.barcodes.map((code) => _barcodeRow(code)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _barcodeRow(String code) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(leading: const Icon(Icons.qr_code), title: Text(code)),
    );
  }
}
