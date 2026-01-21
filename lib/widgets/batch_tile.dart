import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/widgets/batchmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BatchTile extends StatelessWidget {
  final BatchReport batch;
  final VoidCallback onTap;

  const BatchTile({super.key, required this.batch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              batch.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "${batch.quantity} cases • ${batch.location}",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat('dd MMM yyyy • hh:mm a').format(batch.dateTime),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
