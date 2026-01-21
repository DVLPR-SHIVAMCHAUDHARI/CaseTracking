import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/features/reports/models/received_report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceivedReportTile extends StatelessWidget {
  final ReceivedReportModel report;
  final VoidCallback? onTap;

  const ReceivedReportTile({super.key, required this.report, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isStillAssigned = report.stillAssigned == 1;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TOP ROW (Barcode + Status)
            Row(
              children: [
                Expanded(
                  child: Text(
                    report.barcode ?? "-",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isStillAssigned
                        ? AppColors.warning.withOpacity(0.15)
                        : AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isStillAssigned ? "Still Assigned" : "Received",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isStillAssigned
                          ? AppColors.warning
                          : AppColors.success,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔹 BOX SIZE
            _infoRow(
              icon: Icons.inventory_2_outlined,
              label: "Box Size",
              value: report.boxSize ?? "-",
            ),

            const SizedBox(height: 6),

            /// 🔹 RECEIVED DETAILS
            _infoRow(
              icon: Icons.event_available,
              label: "Received",
              value:
                  "${report.receivedDate ?? "-"} • ${report.receivedTime ?? "-"}",
            ),

            const SizedBox(height: 6),

            /// 🔹 LOCATION
            _infoRow(
              icon: Icons.location_on_outlined,
              label: "Location",
              value: report.receivedLocation ?? "-",
            ),

            const SizedBox(height: 6),

            /// 🔹 RECEIVED BY
            _infoRow(
              icon: Icons.person_outline,
              label: "Received By",
              value: report.receivedBy ?? "-",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        SizedBox(width: 8.w),
        Text(
          "$label:",
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
