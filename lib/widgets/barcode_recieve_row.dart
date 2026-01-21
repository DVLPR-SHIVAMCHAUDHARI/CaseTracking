import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/widgets/apptextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BarcodeInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onScan;
  final VoidCallback onAdd;

  const BarcodeInputRow({
    super.key,
    required this.controller,
    required this.onScan,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasText = controller.text.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: AppTextField(
            controller: controller,
            title: "Enter Barcode",
            hint: "ABC-123",
            onChanged: (_) {
              (context as Element).markNeedsBuild();
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 50.h,
          width: 50.w,
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: hasText ? onAdd : onScan,
            icon: Icon(
              hasText ? Icons.arrow_forward_ios : Icons.qr_code_scanner,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
