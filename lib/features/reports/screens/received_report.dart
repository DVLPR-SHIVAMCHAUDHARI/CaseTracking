import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_event.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_state.dart';

import 'package:casetracking/features/master_api/models/box_size_model.dart';
import 'package:casetracking/features/master_api/repositories/masterrepo.dart';
import 'package:casetracking/features/reports/bloc/report_bloc.dart';
import 'package:casetracking/features/reports/bloc/report_event.dart';
import 'package:casetracking/features/reports/bloc/report_state.dart';

import 'package:casetracking/features/reports/models/received_report_model.dart';
import 'package:casetracking/features/reports/screens/receive_detail_report_screen.dart';

import 'package:casetracking/features/reports/widgets/received_report_tile.dart';
import 'package:casetracking/widgets/appdropdown.dart';

import 'package:casetracking/widgets/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceivedReport extends StatefulWidget {
  const ReceivedReport({super.key});

  @override
  State<ReceivedReport> createState() => _ReceivedReportState();
}

class _ReceivedReportState extends State<ReceivedReport> {
  BoxSizeModel? _selectedBoxSize;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  BoxSizeModel? _filterBoxSize;
  String? _sortBy; // e.g. "date", "created_at"
  String _orderBy = "asc";
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportBloc>().add(
        ReceivedReportFetch(
          fromDate: AppDateFormatter.toApi(fromDate),
          toDate: AppDateFormatter.toApi(toDate),
          boxSizeId: _selectedBoxSize?.id,
        ),
      );
    });
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
                  /// FROM DATE
                  Expanded(
                    child: _datePicker(
                      title: "From Date",
                      value: fromDate,
                      onPick: (picked) {
                        setState(() => fromDate = picked);
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// TO DATE
                  Expanded(
                    child: _datePicker(
                      title: "To Date",
                      value: toDate,
                      onPick: (picked) {
                        setState(() => toDate = picked);

                        context.read<ReportBloc>().add(
                          ReceivedReportFetch(
                            fromDate: AppDateFormatter.toApi(fromDate),
                            toDate: AppDateFormatter.toApi(picked),
                            boxSizeId: _selectedBoxSize?.id,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  if (state is ReceivedReportLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ReceivedReportError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is ReceivedReportLoaded) {
                    if (state.reports.isEmpty) {
                      return const Center(
                        child: Text("No received reports found"),
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
                                  ReceivedReportFetch(
                                    fromDate: AppDateFormatter.toApi(fromDate),
                                    toDate: AppDateFormatter.toApi(toDate),
                                    boxSizeId: _selectedBoxSize?.id,
                                    loadMore: true,
                                  ),
                                );
                              },
                              child: const Text("Load More"),
                            ),
                          );
                        }

                        final report = ReceivedReportModel.fromJson(
                          state.reports[index],
                        );
                        return ReceivedReportTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReceivedReportDetailScreen(report: report),
                              ),
                            );
                          },
                          report: report,
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

  /// 🔹 Reusable Date Picker Widget
  Widget _datePicker({
    required String title,
    required DateTime value,
    required Function(DateTime) onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff383838),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) onPick(picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primary.withOpacity(0.15),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppDateFormatter.toApi(value),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const Icon(Icons.calendar_today, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    if (state is BoxSizeLoading) {
                      return AppDropdownShimmer(title: "Box Size");
                    }

                    if (state is BoxSizeLoaded) {
                      return AppDropdown<BoxSizeModel>(
                        title: "Box Size",
                        hint: "Select Box Size",
                        items: state.sizes,
                        value: _filterBoxSize,
                        itemLabel: (b) => b.label,
                        onChanged: (value) {
                          setState(() {
                            _filterBoxSize = value;
                          });
                        },
                      );
                    }

                    if (state is BoxSizeError) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
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
                  items: const ["received_date", "created_at"],
                  value: _sortBy,
                  itemLabel: (v) => v.replaceAll("_", " ").toUpperCase(),
                  onChanged: (value) => _sortBy = value,
                ),

                const SizedBox(height: 12),

                /// ORDER BY
                AppDropdown<String>(
                  title: "Order",
                  hint: "Select",
                  items: const ["asc", "desc"],
                  value: _orderBy,
                  itemLabel: (v) => v.toUpperCase(),
                  onChanged: (value) => _orderBy = value ?? "asc",
                ),

                const SizedBox(height: 20),

                /// ACTIONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _filterBoxSize = null;
                            _sortBy = null;
                            _orderBy = "asc";
                          });
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
                            ReceivedReportFetch(
                              fromDate: AppDateFormatter.toApi(fromDate),
                              toDate: AppDateFormatter.toApi(toDate),
                              boxSizeId: _filterBoxSize?.id,

                              order_by: _orderBy,
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
