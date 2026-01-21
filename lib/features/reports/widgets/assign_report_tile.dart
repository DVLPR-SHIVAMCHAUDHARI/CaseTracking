import 'package:casetracking/features/reports/models/assigned_model.dart';
import 'package:flutter/material.dart';

class AssignedBatchTile extends StatelessWidget {
  final AssignedBatch batch;
  final VoidCallback? onTap;

  const AssignedBatchTile({super.key, required this.batch, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),

        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: const Icon(Icons.inventory_2, color: Colors.blue),
        ),

        title: Text(
          "Batch #${batch.id}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),

            Text("Location: ${batch.locationName}"),
            Text("Assigned By: ${batch.createdBy}"),

            const SizedBox(height: 4),

            Text(
              "Box Size: ${batch.boxSize.length}x${batch.boxSize.width}x${batch.boxSize.height}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 4),

            Text(
              "Barcodes: ${batch.barcodes.length}",
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 4),

            Text(
              "${batch.date} • ${batch.time}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),

        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
