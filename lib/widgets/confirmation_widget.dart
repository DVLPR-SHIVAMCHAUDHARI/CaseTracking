import 'package:flutter/material.dart';
import 'package:casetracking/core/consts/appcolors.dart';

Future<String?> showReasonDialog(
  BuildContext context, {
  required String title,
}) {
  final TextEditingController reasonController = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: TextField(
        controller: reasonController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: "Enter reason...",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            if (reasonController.text.trim().isEmpty) return;
            Navigator.pop(context, reasonController.text.trim());
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}
