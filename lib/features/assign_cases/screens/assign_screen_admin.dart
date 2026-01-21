import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/features/assign_cases/widgets/barcode_scanner.dart';
import 'package:casetracking/widgets/apptextfield.dart';
import 'package:casetracking/widgets/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AssignAdminScreen extends StatefulWidget {
  const AssignAdminScreen({super.key});

  @override
  State<AssignAdminScreen> createState() => _AssignAdminScreenState();
}

class _AssignAdminScreenState extends State<AssignAdminScreen> {
  final List<String> scannedCases = [];
  final TextEditingController barcodeController = TextEditingController();

  final TextEditingController assignToController = TextEditingController(
    text: "Any Warehouse / Company",
  );

  final TextEditingController locationController = TextEditingController(
    text: "Admin Location",
  );

  late DateTime assignedDateTime;

  @override
  void initState() {
    super.initState();
    assignedDateTime = DateTime.now();
  }

  void addCaseFromField() {
    final code = barcodeController.text.trim();
    if (code.isEmpty) return;

    if (!scannedCases.contains(code)) {
      setState(() => scannedCases.add(code));
    }
    barcodeController.clear();
  }

  Future<void> scanCase() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );

    if (result == null || result.trim().isEmpty) return;

    if (!scannedCases.contains(result)) {
      setState(() => scannedCases.add(result));
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: assignedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        assignedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          assignedDateTime.hour,
          assignedDateTime.minute,
        );
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(assignedDateTime),
    );

    if (time != null) {
      setState(() {
        assignedDateTime = DateTime(
          assignedDateTime.year,
          assignedDateTime.month,
          assignedDateTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void assignCases() {
    if (scannedCases.isEmpty) return;

    final dateStr = DateFormat('dd MMM yyyy').format(assignedDateTime);
    final timeStr = DateFormat('hh:mm a').format(assignedDateTime);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Text(
          'Batch Assigned\n'
          'Qty: ${scannedCases.length}\n'
          '$dateStr • $timeStr • ${locationController.text}',
        ),
      ),
    );

    setState(() {
      scannedCases.clear();
      barcodeController.clear();
    });
  }

  @override
  void dispose() {
    barcodeController.dispose();
    assignToController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = barcodeController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assign Cases (Admin)'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// ASSIGN META
              _Card(
                child: Column(
                  children: [
                    AppTextField(
                      title: "Assigning To",
                      controller: assignToController,
                      hint: "Warehouse / Company",
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      title: "Location",
                      controller: locationController,
                      hint: "Enter location",
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            label: "Date",
                            value: DateFormat(
                              'dd MMM yyyy',
                            ).format(assignedDateTime),
                            onTap: pickDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoTile(
                            label: "Time",
                            value: DateFormat(
                              'hh:mm a',
                            ).format(assignedDateTime),
                            onTap: pickTime,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// CASE LIST
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle('Scanned Cases (${scannedCases.length})'),
                    const SizedBox(height: 12),
                    CaseEntryRow(
                      controller: barcodeController,
                      onScan: scanCase,
                      onAdd: addCaseFromField,
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: scannedCases.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) => _caseTile(index),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ASSIGN BUTTON
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: scannedCases.isNotEmpty ? assignCases : null,
                  child: const Text(
                    'Assign Batch',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _caseTile(int index) {
    return Row(
      children: [
        const Icon(Icons.inventory_2, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            scannedCases[index],
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => setState(() => scannedCases.removeAt(index)),
        ),
      ],
    );
  }
}

/// INFO TILE
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
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// CARD
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: child,
    );
  }
}

/// TITLE
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
