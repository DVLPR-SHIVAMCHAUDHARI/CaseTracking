// import 'package:casetracking/core/consts/appcolors.dart';
// import 'package:casetracking/core/consts/snack_bar.dart';
// import 'package:casetracking/features/assign_cases/widgets/barcode_scanner.dart';
// import 'package:casetracking/features/recieve_cases/bloc/recieve_case_bloc.dart';
// import 'package:casetracking/features/recieve_cases/bloc/recieve_case_event.dart';
// import 'package:casetracking/features/recieve_cases/bloc/recieve_case_state.dart';
// import 'package:casetracking/features/recieve_cases/widgets/info_tile.dart';
// import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_bloc.dart';
// import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_event.dart';
// import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_state.dart';
// import 'package:casetracking/widgets/apptextfield.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// class ReceiveStage3Screen extends StatefulWidget {
//   const ReceiveStage3Screen({super.key});

//   @override
//   State<ReceiveStage3Screen> createState() => _ReceiveStage3ScreenState();
// }

// class _ReceiveStage3ScreenState extends State<ReceiveStage3Screen> {
//   /// 🔹 Expected barcodes (DUMMY – replace with API later)
//   final List<String> expectedCases = [];

//   /// 🔹 Received barcodes
//   final List<String> receivedCases = [];

//   final TextEditingController barcodeController = TextEditingController();

//   /// Stage 3: receive from ANY source
//   final TextEditingController receivedFromController = TextEditingController();

//   final TextEditingController locationController = TextEditingController(
//     text: "Nashik Warehouse",
//   );

//   late DateTime receivedDateTime;

//   @override
//   void initState() {
//     super.initState();
//     receivedDateTime = DateTime.now();
//   }

//   /// 🔹 Snackbar helper
//   void _showError(String msg) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(msg)));
//   }

//   /// 🔹 Add barcode from text field
//   void addCaseFromField() {
//     final code = barcodeController.text.trim();
//     if (code.isEmpty) return;

//     if (!expectedCases.contains(code)) {
//       _showError("Invalid barcode");
//       barcodeController.clear();
//       return;
//     }

//     if (receivedCases.contains(code)) {
//       _showError("Already scanned");
//       barcodeController.clear();
//       return;
//     }

//     setState(() => receivedCases.add(code));
//     barcodeController.clear();
//   }

//   /// 🔹 Scan barcode
//   Future<void> scanCase() async {
//     final result = await Navigator.push<String>(
//       context,
//       MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
//     );

//     if (result == null || result.trim().isEmpty) return;
//     final code = result.trim();

//     if (!expectedCases.contains(code)) {
//       _showError("Invalid barcode");
//       return;
//     }

//     if (receivedCases.contains(code)) {
//       _showError("Already scanned");
//       return;
//     }

//     setState(() => receivedCases.add(code));
//   }

//   Future<void> pickDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: receivedDateTime,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );

//     if (date != null) {
//       setState(() {
//         receivedDateTime = DateTime(
//           date.year,
//           date.month,
//           date.day,
//           receivedDateTime.hour,
//           receivedDateTime.minute,
//         );
//       });
//     }
//   }

//   Future<void> pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(receivedDateTime),
//     );

//     if (time != null) {
//       setState(() {
//         receivedDateTime = DateTime(
//           receivedDateTime.year,
//           receivedDateTime.month,
//           receivedDateTime.day,
//           time.hour,
//           time.minute,
//         );
//       });
//     }
//   }

//   /// 🔹 Final receive (FULL BATCH ONLY)
//   void receiveCases() {
//     if (receivedCases.isEmpty) return;

//     context.read<ReceiveBloc>().add(
//       ReceiveCasesEvent(
//         date: DateFormat('yyyy-MM-dd').format(receivedDateTime),
//         time: DateFormat('HH:mm').format(receivedDateTime),
//         barcodes: List.from(receivedCases), // safe copy
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool hasText = barcodeController.text.isNotEmpty;
//     final bool isComplete = receivedCases.length == expectedCases.length;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Receive Cases (Stage 3)'),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: BlocListener<PendingBarcodeBloc, PendingBarcodeState>(
//         listener: (context, state) {
//           if (state is PendingBarcodeLoaded) {
//             setState(() {
//               expectedCases.clear();
//               expectedCases.addAll(state.barcodes);
//             });
//           }

//           if (state is PendingBarcodeError) {
//             snackbar(context, message: state.message, color: AppColors.error);
//           }
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 /// META CARD
//                 BlocListener<ReceiveBloc, ReceiveState>(
//                   listener: (context, state) {
//                     if (state is ReceiveSuccess) {
//                       showCenterNotification(context, message: state.message);

//                       setState(() {
//                         receivedCases.clear();
//                         barcodeController.clear();
//                       });

//                       // refresh pending list
//                       context.read<PendingBarcodeBloc>().add(
//                         const FetchPendingBarcodes(),
//                       );
//                     }

//                     if (state is ReceiveFailure) {
//                       snackbar(
//                         context,
//                         message: state.error,
//                         color: AppColors.error,
//                       );
//                     }
//                   },
//                   child: _CardContainer(
//                     child: Column(
//                       children: [
//                         AppTextField(
//                           title: "Received From",
//                           controller: receivedFromController,
//                           hint: "Warehouse / Company",
//                         ),
//                         const SizedBox(height: 12),
//                         AppTextField(
//                           title: "Location",
//                           controller: locationController,
//                           readOnly: true,
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: InfoTile(
//                                 label: "Date",
//                                 value: DateFormat(
//                                   'dd MMM yyyy',
//                                 ).format(receivedDateTime),
//                                 onTap: pickDate,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: InfoTile(
//                                 label: "Time",
//                                 value: DateFormat(
//                                   'hh:mm a',
//                                 ).format(receivedDateTime),
//                                 onTap: pickTime,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 /// CASES CARD
//                 _CardContainer(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _SectionTitle(
//                         isComplete
//                             ? "All Cases Received (${receivedCases.length})"
//                             : "Received Cases (${receivedCases.length} / ${expectedCases.length})",
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Expanded(
//                             child: AppTextField(
//                               controller: barcodeController,
//                               title: "Enter Barcode",
//                               hint: "ABC-123",
//                               onChanged: (_) => setState(() {}),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           SizedBox(
//                             height: 50.h,
//                             width: 50.w,
//                             child: IconButton.filled(
//                               style: IconButton.styleFrom(
//                                 backgroundColor: AppColors.primary,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               onPressed: hasText ? addCaseFromField : scanCase,
//                               icon: Icon(
//                                 hasText
//                                     ? Icons.arrow_forward_ios
//                                     : Icons.qr_code_scanner,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: receivedCases.length,
//                         separatorBuilder: (_, __) => const Divider(height: 1),
//                         itemBuilder: (_, index) => _caseTile(index),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 /// SUBMIT
//                 BlocBuilder<ReceiveBloc, ReceiveState>(
//                   builder: (context, state) {
//                     if (state is ReceiveLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     return SizedBox(
//                       width: double.infinity,
//                       height: 54.h,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                         ),
//                         onPressed: receivedCases.isNotEmpty
//                             ? receiveCases
//                             : null,
//                         child: const Text(
//                           'Receive Cases',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _caseTile(int index) {
//     return Row(
//       children: [
//         const Icon(Icons.inventory_2, color: AppColors.primary),
//         SizedBox(width: 12.w),
//         Expanded(
//           child: Text(
//             receivedCases[index],
//             style: const TextStyle(color: AppColors.textPrimary),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.delete),
//           onPressed: () => setState(() => receivedCases.removeAt(index)),
//         ),
//       ],
//     );
//   }
// }

// /// INFO TILE

// /// CARD
// class _CardContainer extends StatelessWidget {
//   final Widget child;
//   const _CardContainer({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.card,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
//       ),
//       child: child,
//     );
//   }
// }

// /// SECTION TITLE
// class _SectionTitle extends StatelessWidget {
//   final String text;
//   const _SectionTitle(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         color: AppColors.textPrimary,
//       ),
//     );
//   }
// }
