import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/snack_bar.dart';
import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_bloc.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_event.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_state.dart';

import 'package:casetracking/features/assign_cases/widgets/barcode_scanner.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_state.dart';
import 'package:casetracking/features/master_api/department/bloc/department_bloc.dart';
import 'package:casetracking/features/master_api/department/bloc/department_state.dart';
import 'package:casetracking/features/master_api/models/box_size_model.dart';
import 'package:casetracking/features/master_api/models/department_model.dart';
import 'package:casetracking/features/master_api/models/party_model.dart';
import 'package:casetracking/features/master_api/parties/bloc/parties_bloc.dart';
import 'package:casetracking/features/master_api/parties/bloc/parties_state.dart';
import 'package:casetracking/widgets/appdropdown.dart';
import 'package:casetracking/widgets/apptextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AssignStage2Screen extends StatefulWidget {
  const AssignStage2Screen({super.key});

  @override
  State<AssignStage2Screen> createState() => _AssignStage2ScreenState();
}

class _AssignStage2ScreenState extends State<AssignStage2Screen> {
  List<String> errorBarcodes = [];
  PartyModel? _selectedCompany;
  int? currentDepartmentId;
  BoxSizeModel? _selectedSize;
  final List<String> scannedCases = [];
  final TextEditingController barcodeController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  late DateTime assignedDateTime;

  @override
  void initState() {
    super.initState();
    assignedDateTime = DateTime.now();
    _loadDepartmentId();
  }

  Future<void> _loadDepartmentId() async {
    final rawDeptId = await LocalDb.getDepartmentId();

    debugPrint("RAW departmentId from DB -> '$rawDeptId'");

    setState(() {
      currentDepartmentId = int.tryParse(rawDeptId?.trim() ?? '');
    });
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
      setState(() => scannedCases.add(result.trim()));
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
    if (_selectedCompany == null ||
        _selectedSize == null ||
        scannedCases.isEmpty)
      return;

    context.read<AssignCaseBloc>().add(
      AssignCasesStage2Event(
        locationId: currentDepartmentId!,
        partyId: _selectedCompany!.id,
        boxSizeId: _selectedSize!.id,
        barcodes: List.from(scannedCases),
        date: DateFormat('yyyy-MM-dd').format(assignedDateTime),
        time: DateFormat('HH:mm').format(assignedDateTime),
      ),
    );
  }

  @override
  void dispose() {
    barcodeController.dispose();
    currentDepartmentId = null;
    locationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = barcodeController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assign Cases – Stage 2'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<AssignCaseBloc, AssignCaseState>(
        listener: (context, state) {
          if (state is AssignCase2Loading) {
            // optional: show loader
          }

          if (state is AssignCase2Success) {
            showCenterNotification(context, message: state.message);

            setState(() {
              scannedCases.clear();
              barcodeController.clear();
              _selectedCompany = null;
            });
          }

          if (state is AssignCase2Failure) {
            snackbar(context, message: state.error, color: Colors.red);
            setState(() {
              errorBarcodes = state.failedBarcodes;
            });
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ASSIGN META
                _Card(
                  child: Column(
                    children: [
                      BlocBuilder<PartyBloc, PartyState>(
                        builder: (context, state) {
                          if (state is PartyLoading) {
                            return AppDropdownShimmer(title: "Select company");
                          }

                          if (state is PartyLoaded) {
                            return AppDropdown<PartyModel>(
                              title: "Select Company",
                              hint: "Choose company",
                              items: state.parties,
                              value: _selectedCompany,
                              itemLabel: (p) => p.name,
                              onChanged: (value) {
                                setState(() => _selectedCompany = value);
                              },
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 12),
                      BlocBuilder<DepartmentBloc, DepartmentState>(
                        builder: (context, state) {
                          if (state is DepartmentLoading) {
                            return AppDropdownShimmer(
                              title: "Current Location",
                            );
                          }

                          if (state is DepartmentLoaded) {
                            final currentDept = state.departments.firstWhere(
                              (d) => d.id == currentDepartmentId,
                              orElse: () => state.departments.first,
                            );

                            return AbsorbPointer(
                              child: Opacity(
                                opacity: 1,
                                child: AppDropdown<DepartmentModel>(
                                  title: "Current Location ",
                                  hint: "Current Location",
                                  items: state.departments,
                                  value: currentDept, // ✅ always from SAME list
                                  itemLabel: (d) => d.name,
                                  onChanged: (_) {},
                                ),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 12),

                      BlocBuilder<BoxSizeBloc, BoxSizeState>(
                        builder: (context, state) {
                          if (state is BoxSizeLoading) {
                            return AppDropdownShimmer(title: "Select Box");
                          }

                          if (state is BoxSizeLoaded) {
                            return AppDropdown<BoxSizeModel>(
                              title: "Select Box Size",
                              hint: "Choose Size",
                              items: state.sizes,
                              value: _selectedSize,
                              itemLabel: (b) =>
                                  "${b.length}x${b.width}x${b.height}",
                              onChanged: (value) {
                                setState(() => _selectedSize = value);
                              },
                            );
                          }

                          return const SizedBox.shrink();
                        },
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: barcodeController,
                              title: "Enter Barcode",
                              hint: "ABC-123",
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 50.h,
                            width: 50.w,
                            child: IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary,
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
                    onPressed:
                        _selectedCompany != null &&
                            _selectedSize != null &&
                            currentDepartmentId != null &&
                            scannedCases.isNotEmpty
                        ? assignCases
                        : null,

                    child: const Text(
                      'Assign Cases',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _caseTile(int index) {
    final code = scannedCases[index];
    final bool isError = errorBarcodes.contains(code);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isError ? Colors.red.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError ? Colors.red : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.inventory_2,
            color: isError ? Colors.red : AppColors.primary,
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              code,
              style: TextStyle(
                color: isError ? Colors.red : AppColors.textPrimary,
                fontWeight: isError ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),

          if (isError)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.error, color: Colors.red, size: 18),
            ),

          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                scannedCases.removeAt(index);
                errorBarcodes.remove(code); // ✅ keep clean
              });
            },
          ),
        ],
      ),
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
