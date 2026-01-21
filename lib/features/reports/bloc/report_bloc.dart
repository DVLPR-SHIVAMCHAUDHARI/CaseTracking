import 'package:casetracking/features/reports/repository/report_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepo repo = ReportRepo();

  ReportBloc() : super(AssignedReportInitial()) {
    on<AssignedReportFetch>(_onAssignedFetch);
    on<ReceivedReportFetch>(_onReceivedFetch);
    on<PendingToReceivedFetch>(_onPendingToReceivedFetch);
  }

  /// =========================
  /// COMMON CONFIG
  /// =========================
  final int _limit = 10;

  /// =========================
  /// ASSIGNED REPORT
  /// =========================
  final List<Map<String, dynamic>> _assignedReports = [];
  int _assignedPage = 1;
  String? _assignedDate;
  int? _assignedBoxSize;

  Future<void> _onAssignedFetch(
    AssignedReportFetch event,
    Emitter<ReportState> emit,
  ) async {
    try {
      if (!event.loadMore) {
        emit(AssignedReportLoading());
        _assignedPage = 1;
        _assignedReports.clear();
        _assignedDate = event.date;
        _assignedBoxSize = event.boxSizeId;
      }

      final data = await repo.fetchAssignedList(
        date: _assignedDate,
        boxSize: _assignedBoxSize,
        offset: _assignedPage,
        limit: _limit,
      );

      _assignedReports.addAll(data);
      _assignedPage++;

      emit(
        AssignedReportLoaded(
          reports: List.from(_assignedReports),
          hasMore: data.length == _limit,
        ),
      );
    } catch (e) {
      emit(AssignedReportError(e.toString()));
    }
  }

  /// =========================
  /// RECEIVED REPORT
  /// =========================
  final List<Map<String, dynamic>> _receivedReports = [];
  int _receivedPage = 1;

  Future<void> _onReceivedFetch(
    ReceivedReportFetch event,
    Emitter<ReportState> emit,
  ) async {
    try {
      if (!event.loadMore) {
        emit(ReceivedReportLoading());
        _receivedPage = 1;
        _receivedReports.clear();
      }

      final data = await repo.fetchReceivedReports(
        fromDate: event.fromDate,
        toDate: event.toDate,
        boxSizeId: event.boxSizeId,
        orderBy: event.order_by,
        offset: _receivedPage,
        limit: _limit,
      );

      _receivedReports.addAll(data);
      _receivedPage++;

      emit(
        ReceivedReportLoaded(
          reports: List.from(_receivedReports),
          hasMore: data.length == _limit,
        ),
      );
    } catch (e) {
      emit(ReceivedReportError(e.toString()));
    }
  }

  /// =========================
  /// PENDING → RECEIVED REPORT
  /// =========================
  final List<Map<String, dynamic>> _pendingToReceived = [];
  int _pendingPage = 1;
  int? _pendingBoxSizeId;

  Future<void> _onPendingToReceivedFetch(
    PendingToReceivedFetch event,
    Emitter<ReportState> emit,
  ) async {
    try {
      if (!event.loadMore) {
        emit(PendingToReceivedLoading());
        _pendingPage = 1;
        _pendingToReceived.clear();
        _pendingBoxSizeId = event.boxSizeId;
      }

      final data = await repo.fetchPendingToReceived(
        boxSizeId: _pendingBoxSizeId,
        offset: _pendingPage,
        limit: _limit,
      );

      _pendingToReceived.addAll(data);
      _pendingPage++;

      emit(
        PendingToReceivedLoaded(
          reports: List.from(_pendingToReceived),
          hasMore: data.length == _limit,
        ),
      );
    } catch (e) {
      emit(PendingToReceivedError(e.toString()));
    }
  }
}
