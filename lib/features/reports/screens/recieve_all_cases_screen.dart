import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/snack_bar.dart';
import 'package:casetracking/core/routes/routes.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_state.dart';
import 'package:casetracking/features/master_api/models/box_size_model.dart';
import 'package:casetracking/features/recieve_cases/bloc/recieve_case_bloc.dart';
import 'package:casetracking/features/recieve_cases/bloc/recieve_case_event.dart';
import 'package:casetracking/features/recieve_cases/bloc/recieve_case_state.dart';
import 'package:casetracking/features/reports/bloc/report_bloc.dart';
import 'package:casetracking/features/reports/bloc/report_event.dart';
import 'package:casetracking/features/reports/bloc/report_state.dart';
import 'package:casetracking/features/reports/models/pendin_report_model.dart';
import 'package:casetracking/features/reports/screens/pending_detail_report_screen.dart';
import 'package:casetracking/features/reports/widgets/pending_report_tile.dart';
import 'package:casetracking/widgets/appdropdown.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecieveAllCases extends StatefulWidget {
  const RecieveAllCases({super.key});

  @override
  State<RecieveAllCases> createState() => _RecieveAllCasesState();
}

class _RecieveAllCasesState extends State<RecieveAllCases> {
  BoxSizeModel? _selectedBoxSize;
  final TextEditingController searchCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReceiveBloc, ReceiveState>(
      listener: (context, state) {
        if (state is ReceiveAllCasesFailure) {
          return snackbar(context, message: state.error);
        }
        if (state is ReceiveAllCasesLoaded) {
          context.read<ReportBloc>().add(PendingToReceivedFetch());

          return showCenterNotification(context, message: state.message);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// BOX SIZE FILTER
                    Expanded(
                      child: BlocBuilder<BoxSizeBloc, BoxSizeState>(
                        builder: (context, state) {
                          if (state is BoxSizeLoading) {
                            return AppDropdownShimmer(title: "Box Size");
                          }

                          if (state is BoxSizeLoaded) {
                            return AppDropdown<BoxSizeModel>(
                              title: "Box Size",
                              hint: "Select",
                              items: state.sizes,
                              value: _selectedBoxSize,
                              itemLabel: (b) => b.label,
                              onChanged: (value) {
                                setState(() => _selectedBoxSize = value);
                                context.read<ReportBloc>().add(
                                  PendingToReceivedFetch(boxSizeId: value?.id),
                                );
                              },
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    const SizedBox(width: 12),
                  ],
                ),
              ),

              Expanded(
                child: BlocBuilder<ReportBloc, ReportState>(
                  builder: (context, state) {
                    if (state is PendingToReceivedLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is PendingToReceivedError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is PendingToReceivedLoaded) {
                      if (state.reports.isEmpty) {
                        return const Center(
                          child: Text("No Pending reports found"),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            state.reports.length + (state.hasMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == state.reports.length) {
                            return Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<ReportBloc>().add(
                                    PendingToReceivedFetch(loadMore: true),
                                  );
                                },
                                child: const Text("Load More"),
                              ),
                            );
                          }

                          final batch = PendingToReceivedBatch.fromJson(
                            state.reports[index],
                          );
                          return PendingToReceivedBatchTile(
                            onTap: () async {
                              context.read<ReceiveBloc>().add(
                                ReceiveAllCasesEvent(assignedId: batch.id),
                              );
                            },
                            batch: batch,
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
