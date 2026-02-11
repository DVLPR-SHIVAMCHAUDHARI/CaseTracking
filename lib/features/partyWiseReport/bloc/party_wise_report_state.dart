import 'package:casetracking/features/partyWiseReport/models/party_wise_case_remort_model.dart';
import 'package:equatable/equatable.dart';

abstract class PartyWiseReportState extends Equatable {}

class PartyWiseReportInitial extends PartyWiseReportState {
  @override
  List<Object?> get props => [];
}

class PartyWiseReportLoading extends PartyWiseReportState {
  @override
  List<Object?> get props => [];
}

class PartyWiseReportLoaded extends PartyWiseReportState {
  final List<PartyBoxModel> list;
  final int totalCount;
  final int currentPage;
  final int limit;

  PartyWiseReportLoaded({
    required this.list,
    required this.totalCount,
    required this.currentPage,
    required this.limit,
  });

  @override
  List<Object?> get props => [list, totalCount, currentPage, limit];
}

class PartyWiseReportError extends PartyWiseReportState {
  final String message;

  PartyWiseReportError(this.message);

  @override
  List<Object?> get props => [message];
}
