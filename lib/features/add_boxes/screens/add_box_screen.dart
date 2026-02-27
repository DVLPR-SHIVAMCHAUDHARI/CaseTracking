import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/snack_bar.dart';

import 'package:casetracking/features/add_boxes/bloc/add_box_bloc.dart';
import 'package:casetracking/features/add_boxes/bloc/add_box_event.dart';
import 'package:casetracking/features/add_boxes/bloc/add_box_state.dart';

import 'package:casetracking/features/assign_cases/widgets/barcode_scanner.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_state.dart';

import 'package:casetracking/features/master_api/models/box_size_model.dart';

import 'package:casetracking/widgets/appdropdown.dart';
import 'package:casetracking/widgets/apptextfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddBoxScreen extends StatefulWidget {
  AddBoxScreen({super.key});

  @override
  State<AddBoxScreen> createState() => _AddBoxScreenState();
}

class _AddBoxScreenState extends State<AddBoxScreen> {
  final TextEditingController barcodeCtrl = TextEditingController();
  final TextEditingController boxsizeCtrl = TextEditingController();
  BoxSizeModel? _selectedBoxSize;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    boxsizeCtrl.dispose();
    barcodeCtrl.dispose();
  }

  void addCase(String code) {
    if (code.isEmpty) return;
    setState(() => barcodeCtrl.text = code);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add New Case'),
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
                                "${b.length}X${b.width}X${b.height}",
                            onChanged: (b) {
                              setState(
                                () => boxsizeCtrl.text =
                                    "${b!.length}X${b.width}X${b.height}",
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _card(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // CaseEntryRow(
                    //   controller: barcodeCtrl,
                    //   onScan: scan,
                    //   onAdd: () => addCase(barcodeCtrl.text.trim()),
                    //   onChanged: (_) => setState(() {}),
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AppTextField(
                            title: "Enter Barcode",
                            hint: "Abc-123",
                            controller: barcodeCtrl,
                            onChanged: (p0) {
                              setState(() {});
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
                            onPressed: scan,
                            icon: Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _submitBtn("Add Case"),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitBtn(String label) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: BlocConsumer<AddBoxBloc, AddBoxState>(
        listener: (context, state) {
          if (state is AddNewBoxSuccessState) {
            showCenterNotification(context, message: state.message);
            setState(() {
              barcodeCtrl.clear();
            });
          }
          if (state is AddNewBoxFailureState) {
            snackbar(context, message: state.error, color: Colors.red);
          }
        },
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed:
                barcodeCtrl.text.isNotEmpty && boxsizeCtrl.text.isNotEmpty
                ? () {
                    context.read<AddBoxBloc>().add(
                      AddNewBoxEvent(barcodeCtrl.text, boxsizeCtrl.text),
                    );
                  }
                : null,
            child: state is AddNewBoxLoadingState
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
