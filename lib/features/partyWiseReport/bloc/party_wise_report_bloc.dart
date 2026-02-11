import 'package:casetracking/core/services/local_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'party_wise_report_event.dart';
import 'party_wise_report_state.dart';
import '../repository/party_wise_repository.dart';

class PartyWiseReportBloc
    extends Bloc<PartyWiseReportEvent, PartyWiseReportState> {
  final PartyWiseRepository repository;

  PartyWiseReportBloc(this.repository) : super(PartyWiseReportInitial()) {
    on<FetchPartyReport>(_onFetchPartyReport);
  }

  Future<void> _onFetchPartyReport(
    FetchPartyReport event,
    Emitter<PartyWiseReportState> emit,
  ) async {
    emit(PartyWiseReportLoading());

    try {
      final response = await repository.getPartyBoxes(
        departmentId: await LocalDb.getDepartmentId(),
        partyName: event.partyId?.toString(),
        barcode: event.barcode,
        boxSize: event.boxSize,
        sortBy: event.sortBy,
        orderBy: event.orderBy,
        offset: event.offset,
        limit: event.limit,
      );

      emit(
        PartyWiseReportLoaded(
          list: response.list,
          totalCount: response.count,
          currentPage: event.offset,
          limit: event.limit,
        ),
      );
    } catch (e) {
      emit(PartyWiseReportError(e.toString()));
    }
  }
}
