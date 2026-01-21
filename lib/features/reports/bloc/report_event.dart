import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class AssignedReportFetch extends ReportEvent {
  final String? date;
  final int? boxSizeId;
  final String? sortBy;
  final String? orderBy;
  final bool loadMore;

  const AssignedReportFetch({
    this.date,
    this.boxSizeId,
    this.sortBy,
    this.orderBy,
    this.loadMore = false,
  });
}

class ReceivedReportFetch extends ReportEvent {
  final String fromDate;
  final String toDate;
  final int? boxSizeId;
  final bool loadMore;
  String? order_by;

  ReceivedReportFetch({
    required this.fromDate,
    this.order_by,
    required this.toDate,
    this.boxSizeId,
    this.loadMore = false,
  });
}

class PendingToReceivedFetch extends ReportEvent {
  final int? boxSizeId;
  final String? sortBy;
  final String? orderBy;
  final bool loadMore;

  const PendingToReceivedFetch({
    this.boxSizeId,
    this.sortBy,
    this.orderBy,
    this.loadMore = false,
  });
}
