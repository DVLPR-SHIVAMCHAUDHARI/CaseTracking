import 'package:casetracking/core/consts/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeRow extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;

  const DateTimeRow({
    super.key,
    required this.dateTime,
    required this.onDateTap,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            label: "Date",
            value: DateFormat('dd MMM yyyy').format(dateTime),
            onTap: onDateTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoTile(
            label: "Time",
            value: DateFormat('hh:mm a').format(dateTime),
            onTap: onTimeTap,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
