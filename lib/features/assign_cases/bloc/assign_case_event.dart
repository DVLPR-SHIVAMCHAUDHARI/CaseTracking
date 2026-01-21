import 'package:equatable/equatable.dart';

abstract class AssignCaseEvent extends Equatable {
  const AssignCaseEvent();

  @override
  List<Object?> get props => [];
}

class AssignCasesStage2Event extends AssignCaseEvent {
  final int locationId;
  final int partyId;

  final int boxSizeId;

  final List barcodes;
  final String date;
  final String time;

  const AssignCasesStage2Event({
    required this.locationId,
    required this.partyId,
    required this.boxSizeId,
    required this.barcodes,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [
    locationId,
    partyId,
    boxSizeId,
    barcodes,
    date,
    time,
  ];
}

class AssignCasesStage1Event extends AssignCaseEvent {
  final int locationId;
  final int boxSizeId;
  final List<String> barcodes;
  final String date;
  final String time;

  const AssignCasesStage1Event({
    required this.locationId,
    required this.boxSizeId,
    required this.barcodes,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [locationId, boxSizeId, barcodes, date, time];
}

class AssignCasesStage3Event extends AssignCaseEvent {
  final int locationId;
  final int boxSizeId;
  final List<String> barcodes;
  final String date;
  final String time;

  const AssignCasesStage3Event({
    required this.locationId,
    required this.boxSizeId,
    required this.barcodes,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [locationId, boxSizeId, barcodes, date, time];
}
