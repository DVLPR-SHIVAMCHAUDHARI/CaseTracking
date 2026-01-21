import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/features/reports/models/pendin_report_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingToReceivedBatchTile extends StatelessWidget {
  final PendingToReceivedBatch batch;
  final VoidCallback? onTap;

  const PendingToReceivedBatchTile({
    super.key,
    required this.batch,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Batch #${batch.id}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _chip(
                  "${batch.barcodes.length} Boxes",
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// LOCATION
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    batch.locationName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// DATE + TIME
            Row(
              children: [
                _infoText("Date", batch.date),
                const SizedBox(width: 16),
                _infoText("Time", batch.time),
              ],
            ),

            const SizedBox(height: 10),

            /// BOX SIZE
            _infoText(
              "Box Size",
              "${batch.boxSizeDetails.length}×"
                  "${batch.boxSizeDetails.width}×"
                  "${batch.boxSizeDetails.height}",
            ),

            const SizedBox(height: 10),

            /// CREATED BY
            _infoText("Created By", batch.createdBy),

            const SizedBox(height: 12),

            /// BARCODE PREVIEW
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  batch.barcodes.take(3).map((code) {
                    return _barcodeChip(code);
                  }).toList()..addAll(
                    batch.barcodes.length > 3
                        ? [
                            _barcodeChip(
                              "+${batch.barcodes.length - 3} more",
                              isMuted: true,
                            ),
                          ]
                        : [],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Small label-value text
  Widget _infoText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label: ",
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Count chip
  Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }

  /// 🔹 Barcode chip
  Widget _barcodeChip(String text, {bool isMuted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isMuted
            ? Colors.grey.shade200
            : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isMuted ? Colors.grey : AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
