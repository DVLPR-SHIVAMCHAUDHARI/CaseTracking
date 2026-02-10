import 'package:casetracking/core/consts/globals.dart';
import 'package:casetracking/core/consts/snack_bar.dart';
import 'package:casetracking/core/routes/routes.dart';
import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/features/recieve_cases/bloc/recieve_case_bloc.dart';
import 'package:casetracking/features/recieve_cases/bloc/recieve_case_event.dart';
import 'package:casetracking/features/recieve_cases/bloc/recieve_case_state.dart';
import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_bloc.dart';
import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_event.dart';
import 'package:casetracking/features/reports/bloc/report_bloc.dart';
import 'package:casetracking/features/reports/bloc/report_event.dart';
import 'package:casetracking/features/reports/bloc/report_state.dart';
import 'package:casetracking/features/reports/models/pendin_report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PendingToReceivedDetailScreen extends StatefulWidget {
  final PendingToReceivedBatch batch;

  PendingToReceivedDetailScreen({super.key, required this.batch});

  @override
  State<PendingToReceivedDetailScreen> createState() =>
      _PendingToReceivedDetailScreenState();
}

class _PendingToReceivedDetailScreenState
    extends State<PendingToReceivedDetailScreen> {
  String? stageid;

  bool _isStage2 = false;
  getStageid() async {
    stageid = await LocalDb.getStageId();
    if (stageid == "2") {
      setState(() {
        _isStage2 = true;
      });
    }
  }

  @override
  void initState() {
    getStageid();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Batch #${widget.batch.id}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: BlocListener<ReceiveBloc, ReceiveState>(
            listener: (context, state) {
              if (state is ReceiveAllCasesLoading) {
                Center(child: CircularProgressIndicator());
              }
              if (state is ReceiveAllCasesLoaded) {
                snackbar(
                  context,
                  message: state.message,
                  color: Colors.green,
                  title: "Great!",
                );
                context.pop(true);
              } else if (state is ReceiveAllCasesFailure) {
                snackbar(
                  context,
                  message: state.error,
                  color: Colors.red,
                  title: "Error!",
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _info("Location", widget.batch.locationName),
                _info("Created By", widget.batch.createdBy),
                _info(
                  "Box Size",
                  "${widget.batch.boxSizeDetails.length}×${widget.batch.boxSizeDetails.width}×${widget.batch.boxSizeDetails.height}",
                ),
                _info("Date", "${widget.batch.date} • ${widget.batch.time}"),

                const SizedBox(height: 16),
                _title("Barcodes (${widget.batch.barcodes.length})"),

                ...widget.batch.barcodes.map(_barcodeTile),

                _isStage2
                    ? SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ReceiveBloc>().add(
                              ReceiveAllCasesEvent(assignedId: widget.batch.id),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Assign All",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String text) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _barcodeTile(String code) {
    return ListTile(leading: const Icon(Icons.inventory_2), title: Text(code));
  }
}
