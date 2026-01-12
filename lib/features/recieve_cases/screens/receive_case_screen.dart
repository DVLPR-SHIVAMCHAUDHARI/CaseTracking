import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/features/assign_cases/widgets/barcode_scanner.dart';
import 'package:casetracking/widgets/appdropdown.dart';
import 'package:casetracking/widgets/apptextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReceiveCaseScreen extends StatefulWidget {
  const ReceiveCaseScreen({super.key});

  @override
  State<ReceiveCaseScreen> createState() => _ReceiveCaseScreenState();
}

class _ReceiveCaseScreenState extends State<ReceiveCaseScreen> {
  String? selectedCompany;
  final List<String> receivedCases = [];
  final TextEditingController manualController = TextEditingController();

  final TextEditingController locationController = TextEditingController(
    text: "Warehouse A",
  );

  late DateTime receivedDateTime;

  final List<String> companies = [
    'ABC Logistics',
    'Delta Services',
    'Omega Works',
    'Rapid Movers',
  ];

  @override
  void initState() {
    super.initState();
    receivedDateTime = DateTime.now();
  }

  void addCaseFromField() {
    final code = manualController.text.trim();
    if (code.isEmpty) return;

    if (!receivedCases.contains(code)) {
      setState(() => receivedCases.add(code));
    }

    manualController.clear();
  }

  Future<void> scanCase() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );

    if (result == null) return;

    final code = result.trim();
    if (code.isEmpty) return;

    if (!receivedCases.contains(code)) {
      setState(() => receivedCases.add(code));
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: receivedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        receivedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          receivedDateTime.hour,
          receivedDateTime.minute,
        );
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(receivedDateTime),
    );

    if (time != null) {
      setState(() {
        receivedDateTime = DateTime(
          receivedDateTime.year,
          receivedDateTime.month,
          receivedDateTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void receiveCases() {
    if (selectedCompany == null || receivedCases.isEmpty) return;

    final dateStr = DateFormat('dd MMM yyyy').format(receivedDateTime);
    final timeStr = DateFormat('hh:mm a').format(receivedDateTime);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Text(
          '${receivedCases.length} cases received from $selectedCompany\n$dateStr • $timeStr • ${locationController.text}',
        ),
      ),
    );

    setState(() {
      receivedCases.clear();
      selectedCompany = null;
      manualController.clear();
    });
  }

  @override
  void dispose() {
    manualController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = manualController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: const Text('Receive Cases'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// RECEIVE META
                _CardContainer(
                  child: Column(
                    children: [
                      AppDropdown(
                        title: "Received From Company",
                        hint: "Select company",
                        items: companies,
                        value: selectedCompany,
                        onChanged: (String? value) {
                          setState(() => selectedCompany = value);
                        },
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
                              ).format(receivedDateTime),
                              onTap: pickDate,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InfoTile(
                              label: "Time",
                              value: DateFormat(
                                'hh:mm a',
                              ).format(receivedDateTime),
                              onTap: pickTime,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// CASES CARD
                _CardContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle('Received Cases (${receivedCases.length})'),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: manualController,
                              title: "Enter Barcode",
                              hint: "ABC-abc-1234",
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 50.h,
                            width: 50.w,
                            child: IconButton.filled(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: hasText ? addCaseFromField : scanCase,
                              icon: Icon(
                                hasText
                                    ? Icons.arrow_forward_ios
                                    : Icons.qr_code_scanner,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: receivedCases.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, index) => _customListTile(index),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// RECEIVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed:
                        selectedCompany != null && receivedCases.isNotEmpty
                        ? receiveCases
                        : null,
                    icon: const Icon(
                      Icons.assignment_turned_in,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Receive Cases',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _customListTile(int index) {
    return Row(
      children: [
        Icon(Icons.inventory_2, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            receivedCases[index],
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => setState(() => receivedCases.removeAt(index)),
        ),
      ],
    );
  }
}

/// INFO TILE (DATE / TIME)
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

/// REUSABLE CARD
class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

/// SECTION TITLE
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
