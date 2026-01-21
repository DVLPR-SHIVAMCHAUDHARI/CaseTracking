import 'package:casetracking/widgets/batchmodel.dart';
import 'package:casetracking/widgets/confirmation_widget.dart';
import 'package:flutter/material.dart';
import 'package:casetracking/core/consts/appcolors.dart';
import 'package:intl/intl.dart';

class BatchTileWithActions extends StatelessWidget {
  final BatchReport batch;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback onOpen;
  final VoidCallback onDeleteConfirmed;
  final ValueChanged<String> onEditConfirmed;

  const BatchTileWithActions({
    super.key,
    required this.batch,
    required this.onOpen,
    required this.canEdit,
    required this.canDelete,
    required this.onDeleteConfirmed,
    required this.onEditConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Expanded(
                child: Text(
                  batch.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: onOpen,
              ),
            ],
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

          if (canEdit || canDelete) ...[
            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (canEdit)
                  TextButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      final reason = await showReasonDialog(
                        context,
                        title: "Reason for Edit",
                      );
                      if (reason != null) {
                        onEditConfirmed(reason);
                      }
                    },
                  ),
                if (canDelete)
                  TextButton.icon(
                    icon: const Icon(Icons.delete, color: AppColors.error),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: AppColors.error),
                    ),
                    onPressed: () async {
                      final reason = await showReasonDialog(
                        context,
                        title: "Reason for Delete",
                      );
                      if (reason != null) {
                        onDeleteConfirmed();
                      }
                    },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
