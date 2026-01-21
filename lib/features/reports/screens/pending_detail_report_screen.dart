import 'package:casetracking/features/reports/models/pendin_report_model.dart';
import 'package:flutter/material.dart';

class PendingToReceivedDetailScreen extends StatelessWidget {
  final PendingToReceivedBatch batch;

  const PendingToReceivedDetailScreen({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Batch #${batch.id}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info("Location", batch.locationName),
            _info("Created By", batch.createdBy),
            _info(
              "Box Size",
              "${batch.boxSizeDetails.length}×${batch.boxSizeDetails.width}×${batch.boxSizeDetails.height}",
            ),
            _info("Date", "${batch.date} • ${batch.time}"),

            const SizedBox(height: 16),
            _title("Barcodes (${batch.barcodes.length})"),

            ...batch.barcodes.map(_barcodeTile),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _barcodeTile(String code) {
    return ListTile(leading: const Icon(Icons.inventory_2), title: Text(code));
  }
}
