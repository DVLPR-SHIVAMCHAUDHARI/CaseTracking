import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_state.dart';
import 'package:casetracking/features/master_api/models/box_size_model.dart';
import 'package:casetracking/features/reports/bloc/report_bloc.dart';
import 'package:casetracking/features/reports/bloc/report_event.dart';
import 'package:casetracking/features/reports/bloc/report_state.dart';
import 'package:casetracking/features/reports/models/pendin_report_model.dart';
import 'package:casetracking/features/reports/screens/pending_detail_report_screen.dart';

import 'package:casetracking/features/reports/widgets/assign_report_tile.dart';
import 'package:casetracking/features/reports/widgets/pending_report_tile.dart';
import 'package:casetracking/features/reports/widgets/search_bar.dart';
import 'package:casetracking/widgets/appdropdown.dart';
import 'package:casetracking/widgets/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingReport extends StatefulWidget {
  const PendingReport({super.key});

  @override
  State<PendingReport> createState() => _PendingReportState();
}

class _PendingReportState extends State<PendingReport> {
  BoxSizeModel? _selectedBoxSize;
  final TextEditingController searchCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();
  BoxSizeModel? _filterBoxSize;
  String? _sortBy;
  String _orderBy = "asc";

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.filter_list),
        onPressed: () => _openFilterSheet(context),
      ),
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
                      itemCount: state.reports.length + (state.hasMore ? 1 : 0),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PendingToReceivedDetailScreen(batch: batch),
                              ),
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
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filters",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                /// BOX SIZE
                BlocBuilder<BoxSizeBloc, BoxSizeState>(
                  builder: (context, state) {
                    if (state is BoxSizeLoaded) {
                      return AppDropdown<BoxSizeModel>(
                        title: "Box Size",
                        hint: "Select",
                        items: state.sizes,
                        value: _filterBoxSize,
                        itemLabel: (b) => b.label,
                        onChanged: (v) => _filterBoxSize = v,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 12),

                /// SORT BY
                AppDropdown<String>(
                  title: "Sort By",
                  hint: "Select",
                  items: const ["created_at", "date"],
                  value: _sortBy,
                  itemLabel: (v) => v.replaceAll("_", " ").toUpperCase(),
                  onChanged: (v) => _sortBy = v,
                ),

                const SizedBox(height: 12),

                /// ORDER BY
                AppDropdown<String>(
                  title: "Order",
                  hint: "Select",
                  items: const ["asc", "desc"],
                  value: _orderBy,
                  itemLabel: (v) => v.toUpperCase(),
                  onChanged: (v) => _orderBy = v ?? "asc",
                ),

                const SizedBox(height: 20),

                /// ACTIONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _filterBoxSize = null;
                          _sortBy = null;
                          _orderBy = "asc";
                          Navigator.pop(context);
                        },
                        child: const Text("Clear"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          context.read<ReportBloc>().add(
                            PendingToReceivedFetch(
                              boxSizeId: _filterBoxSize?.id,
                              sortBy: _sortBy,
                              orderBy: _orderBy,
                            ),
                          );
                        },
                        child: const Text("Apply"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
