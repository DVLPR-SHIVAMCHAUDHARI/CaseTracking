import 'package:casetracking/core/consts/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// MOCK DATA (replace with real data later)
    final List<CaseReport> reports = [
      CaseReport(
        company: "ABC Logistics",
        date: "12 Sep 2024",
        assigned: 120,
        received: 110,
      ),
      CaseReport(
        company: "Delta Services",
        date: "12 Sep 2024",
        assigned: 90,
        received: 90,
      ),
      CaseReport(
        company: "Omega Works",
        date: "11 Sep 2024",
        assigned: 75,
        received: 60,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Reports"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _ReportCard(report: reports[index]);
          },
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final CaseReport report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final int missing = report.assigned - report.received;
    final bool hasMissing = missing > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.company,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                report.date,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatTile(
                label: "Assigned",
                value: report.assigned.toString(),
                color: AppColors.primary,
              ),
              _StatTile(
                label: "Received",
                value: report.received.toString(),
                color: AppColors.success,
              ),
              _StatTile(
                label: "Missing",
                value: missing.toString(),
                color: hasMissing ? AppColors.error : AppColors.textSecondary,
              ),
            ],
          ),

          if (hasMissing) ...[
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.warning_amber, color: AppColors.error, size: 18),
                SizedBox(width: 6),
                Text(
                  "Missing cases detected",
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// DATA MODEL
class CaseReport {
  final String company;
  final String date;
  final int assigned;
  final int received;

  CaseReport({
    required this.company,
    required this.date,
    required this.assigned,
    required this.received,
  });
}
