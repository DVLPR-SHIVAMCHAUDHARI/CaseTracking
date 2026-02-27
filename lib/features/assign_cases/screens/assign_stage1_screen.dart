import 'dart:developer';

import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/globals.dart';
import 'package:casetracking/core/consts/snack_bar.dart';
import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_bloc.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_event.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_state.dart';
import 'package:casetracking/features/assign_cases/widgets/barcode_scanner.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_state.dart';
import 'package:casetracking/features/master_api/department/bloc/department_bloc.dart';
import 'package:casetracking/features/master_api/department/bloc/department_event.dart';
import 'package:casetracking/features/master_api/department/bloc/department_state.dart';
import 'package:casetracking/features/master_api/models/box_size_model.dart';
import 'package:casetracking/features/master_api/models/department_model.dart';
import 'package:casetracking/widgets/appdropdown.dart';
import 'package:casetracking/widgets/apptextfield.dart';
import 'package:casetracking/widgets/datetimerow.dart';
import 'package:casetracking/widgets/caseEntryRowWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AssignStage1Screen extends StatefulWidget {
  AssignStage1Screen({super.key});

  @override
  State<AssignStage1Screen> createState() => _AssignStage1ScreenState();
}

late DateTime assignedDateTime;

DepartmentModel? _selectedDepartment; // Send To
String? currentDepartmentId;

BoxSizeModel? _selectedBoxSize;

class _AssignStage1ScreenState extends State<AssignStage1Screen> {
  final List<String> cases = [];
  List<String> errorBarcodes = [];

  final TextEditingController barcodeCtrl = TextEditingController();

  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    localLoad();
  }

  localLoad() async {
    currentDepartmentId = await LocalDb.getDepartmentId();
    logger.e(currentDepartmentId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _selectedBoxSize = null;
    _selectedDepartment = null;
    barcodeCtrl.dispose();
  }

  void addCase(String code) {
    if (code.isEmpty || cases.contains(code)) return;
    setState(() => cases.add(code));
    barcodeCtrl.clear();
  }

  Future<void> scan() async {
    final res = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
    if (res != null) addCase(res.trim());
  }

  @override
  Widget build(BuildContext context) {
    final hasText = barcodeCtrl.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assign Cases – Stage 1'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _card(
                Column(
                  children: [
                    BlocBuilder<DepartmentBloc, DepartmentState>(
                      builder: (context, state) {
                        if (state is DepartmentLoading) {
                          return AppDropdownShimmer(title: "Send to");
                        }

                        if (state is DepartmentLoaded) {
                          return AppDropdown<DepartmentModel>(
                            title: "Send to",
                            hint: "Choose Location",
                            items: state.departments,
                            value: _selectedDepartment,
                            itemLabel: (d) => d.name,
                            onChanged: (value) {
                              setState(() => _selectedDepartment = value);
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
                          return AppDropdownShimmer(title: "Current Location");
                        }

                        if (state is DepartmentLoaded) {
                          final currentDept = state.departments.firstWhere(
                            (d) =>
                                d.id == int.tryParse(currentDepartmentId ?? ""),
                            orElse: () => state.departments.first,
                          );

                          return AbsorbPointer(
                            child: Opacity(
                              opacity: 1,
                              child: AppDropdown<DepartmentModel>(
                                title: "Current Location ",
                                hint: "Current Location",
                                items: state.departments,
                                value: currentDept,
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
                            hint: "Choose Box Size",
                            items: state.sizes,
                            value: _selectedBoxSize,
                            itemLabel: (b) =>
                                "${b.length}x${b.width}x${b.height}",
                            onChanged: (value) {
                              setState(() => _selectedBoxSize = value);
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 12),
                    DateTimeRow(
                      dateTime: dateTime,
                      onDateTap: () {},
                      onTimeTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _card(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Scanned Cases (${cases.length})", style: _title()),
                    const SizedBox(height: 12),
                    CaseEntryRow(
                      controller: barcodeCtrl,
                      onScan: scan,
                      onAdd: () => addCase(barcodeCtrl.text.trim()),
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cases.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) => _caseTile(index),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _submitBtn("Assign Cases"),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _caseTile(int index) {
    final code = cases[index];
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
                cases.removeAt(index);
                errorBarcodes.remove(code); // ✅ keep clean
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _submitBtn(String label) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: BlocConsumer<AssignCaseBloc, AssignCaseState>(
        listener: (context, state) {
          if (state is AssignCase1Success) {
            showCenterNotification(context, message: state.message);
            setState(() => cases.clear());
          }
          if (state is AssignCase1Failure) {
            snackbar(context, message: state.error, color: Colors.red);
            setState(() {
              errorBarcodes = state.failedBarcodes;
            });
          }
        },
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: (cases.isNotEmpty && state is! AssignCase1Loading)
                ? () {
                    context.read<AssignCaseBloc>().add(
                      AssignCasesStage1Event(
                        locationId: _selectedDepartment!.id,
                        boxSizeId: _selectedBoxSize!.id,
                        barcodes: cases,
                        date: DateFormat('yyyy-MM-dd').format(dateTime),
                        time: DateFormat('HH:mm').format(dateTime),
                      ),
                    );
                  }
                : null,
            child: state is AssignCase1Loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(label, style: const TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
    ),
    child: child,
  );

  TextStyle _title() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
}
