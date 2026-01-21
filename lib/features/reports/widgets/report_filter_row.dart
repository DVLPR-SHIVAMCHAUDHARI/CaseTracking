import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportFilterRow extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onDateTap;

  final String? selectedBoxSize;
  final ValueChanged<String?> onBoxSizeChanged;

  const ReportFilterRow({
    super.key,
    required this.selectedDate,
    required this.onDateTap,
    required this.selectedBoxSize,
    required this.onBoxSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          /// DATE PICKER
          Expanded(
            child: _filterBox(
              onTap: onDateTap,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    selectedDate == null
                        ? "Select Date"
                        : DateFormat('dd MMM yyyy').format(selectedDate!),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// BOX SIZE DROPDOWN
          Expanded(
            child: _filterBox(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedBoxSize,
                  hint: const Text("Box Size"),
                  isExpanded: true,
                  items: const ["300×300×300", "400×400×450", "500×500×400"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: onBoxSizeChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBox({required Widget child, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
