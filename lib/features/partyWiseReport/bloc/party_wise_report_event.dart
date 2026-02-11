import 'package:equatable/equatable.dart';

abstract class PartyWiseReportEvent extends Equatable {
  const PartyWiseReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchPartyReport extends PartyWiseReportEvent {
  final int? partyId;
  final String? departmentId;
  final String? barcode;
  final String? boxSize;
  final String? sortBy;
  final String? orderBy;
  final int offset;
  final int limit;

  const FetchPartyReport({
    this.partyId,
    this.departmentId,
    this.barcode,
    this.boxSize,
    this.sortBy,
    this.orderBy,
    this.offset = 1,
    this.limit = 100,
  });

  @override
  List<Object?> get props => [
    partyId,
    departmentId,
    barcode,
    boxSize,
    sortBy,
    orderBy,
    offset,
    limit,
  ];
}
