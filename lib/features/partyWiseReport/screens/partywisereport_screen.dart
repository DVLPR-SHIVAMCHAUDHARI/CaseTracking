import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_state.dart';
import 'package:casetracking/features/master_api/models/box_size_model.dart';
import 'package:casetracking/features/master_api/models/party_model.dart';
import 'package:casetracking/features/master_api/parties/bloc/parties_bloc.dart';
import 'package:casetracking/features/master_api/parties/bloc/parties_state.dart';
import 'package:casetracking/features/partyWiseReport/bloc/party_wise_report_bloc.dart';
import 'package:casetracking/features/partyWiseReport/bloc/party_wise_report_event.dart';
import 'package:casetracking/features/partyWiseReport/bloc/party_wise_report_state.dart';
import 'package:casetracking/widgets/appdropdown.dart';
import 'package:casetracking/widgets/apptextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartyWiseReport extends StatefulWidget {
  const PartyWiseReport({super.key});

  @override
  State<PartyWiseReport> createState() => _PartyWiseReportState();
}

class _PartyWiseReportState extends State<PartyWiseReport> {
  PartyModel? _selectedParty;

  int? _selectedBoxSizeId;
  String _sortBy = "created_at";
  String _orderBy = "asc";

  final PartyModel _allParty = PartyModel(id: 0, name: "All Parties");

  final TextEditingController _barcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text(
          "Party Wise Case Report",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),

      /// 🔵 FLOATING FILTER BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: _openFilterSheet,
        icon: const Icon(Icons.filter_list, color: Colors.white),
        label: const Text("Filters", style: TextStyle(color: Colors.white)),
      ),

      body: SafeArea(
        child: BlocBuilder<PartyWiseReportBloc, PartyWiseReportState>(
          builder: (context, state) {
            if (state is PartyWiseReportLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PartyWiseReportError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is PartyWiseReportLoaded) {
              if (state.list.isEmpty) {
                return const Center(child: Text("No data found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.list.length,
                itemBuilder: (_, index) {
                  final item = state.list[index];

                  final created = DateTime.parse(item.createdAt!);
                  final days = DateTime.now().difference(created).inDays;
                  final isOverdue = days > 21;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: isOverdue
                            ? Border.all(color: Colors.red, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ID: ${item.id}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),

                          _infoRow("Barcode", item.barcode),
                          _infoRow("Party", item.partyName),
                          _infoRow("Case Size", item.boxSize),
                          _infoRow("Assigned Date", item.createdAt),
                          _infoRow("Assigned By", item.createdBy),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Text(
                                "Days Assigned: ",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                days.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isOverdue ? Colors.red : Colors.green,
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

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// 🔽 FILTER BOTTOM SHEET
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PartyBloc>()),
            BlocProvider.value(value: context.read<PartyWiseReportBloc>()),
            BlocProvider.value(value: context.read<BoxSizeBloc>()),
          ],
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// PARTY DROPDOWN
                    BlocBuilder<PartyBloc, PartyState>(
                      builder: (context, state) {
                        if (state is PartyLoading) {
                          return const AppDropdownShimmer(title: "Party");
                        }

                        if (state is PartyLoaded) {
                          final parties = [_allParty, ...state.parties];

                          return AppDropdown2<PartyModel>(
                            title: "Select Party",
                            hint: "Choose Party",
                            items: parties,
                            value: _selectedParty ?? _allParty,
                            label: (d) => d.name,
                            onChanged: (v) {
                              setState(() {
                                _selectedParty = v?.id == 0 ? null : v;
                              });
                            },
                          );
                        }

                        if (state is PartyError) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 12),

                    /// BARCODE
                    AppTextField(
                      title: "Enter Barcode",
                      hint: "Search by barcode",
                      controller: _barcodeController,
                    ),

                    const SizedBox(height: 12),

                    /// BOX SIZE
                    BlocBuilder<BoxSizeBloc, BoxSizeState>(
                      builder: (context, state) {
                        if (state is BoxSizeLoading) {
                          return AppDropdownShimmer(title: "Department");
                        }

                        if (state is BoxSizeLoaded) {
                          final sizes = [
                            BoxSizeModel(
                              id: 0,
                              height: 0,
                              width: 0,
                              length: 0,
                              isDeleted: false,
                              createdAt: '',
                              updatedAt: '',
                            ), // fake
                            ...state.sizes,
                          ];

                          return AppDropdown2<int>(
                            title: "Select Box Size",
                            hint: "All Sizes",
                            items: [0, ...state.sizes.map((e) => e.id!)],
                            value: _selectedBoxSizeId ?? 0,
                            label: (id) {
                              if (id == 0) return "All Sizes";
                              final size = state.sizes.firstWhere(
                                (e) => e.id == id,
                              );
                              return "${size.height}x${size.width}x${size.length}";
                            },
                            onChanged: (v) {
                              setState(() {
                                _selectedBoxSizeId = v == 0 ? null : v;
                              });
                            },
                          );
                        } else if (state is BoxSizeError) {
                          return Text(
                            "Error loading Boxsize: ${state.message}",
                            style: const TextStyle(color: Colors.red),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 12),

                    /// SORT ORDER
                    AppDropdown2<String>(
                      title: "Sort Order",
                      hint: "Select Order",
                      items: const ["asc", "desc"],
                      value: _orderBy,
                      label: (d) => d.toUpperCase(),
                      onChanged: (v) {
                        setState(() {
                          _orderBy = v ?? "asc";
                        });

                        // Refetch with new order
                        String? boxSize;

                        if (_selectedBoxSizeId != null) {
                          final boxState = context.read<BoxSizeBloc>().state;

                          if (boxState is BoxSizeLoaded) {
                            final size = boxState.sizes.firstWhere(
                              (e) => e.id == _selectedBoxSizeId,
                            );

                            boxSize =
                                "${size.height}x${size.width}x${size.length}";
                          }
                        }

                        context.read<PartyWiseReportBloc>().add(
                          FetchPartyReport(
                            partyId: _selectedParty?.id,
                            barcode: _barcodeController.text.trim().isEmpty
                                ? null
                                : _barcodeController.text.trim(),
                            boxSize: boxSize,
                            sortBy: _sortBy,
                            orderBy: _orderBy,
                            offset: 1,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    /// APPLY BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final barcode = _barcodeController.text.trim();

                          context.read<PartyWiseReportBloc>().add(
                            FetchPartyReport(
                              partyId: _selectedParty?.id,
                              barcode: barcode.isEmpty ? null : barcode,
                              boxSize: _selectedBoxSizeId.toString(),
                              sortBy: "created_at",
                              orderBy: _orderBy,
                              offset: 1,
                            ),
                          );

                          Navigator.pop(sheetContext);
                        },
                        child: const Text("Apply Filters"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
