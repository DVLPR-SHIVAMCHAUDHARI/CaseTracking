import 'package:equatable/equatable.dart';

abstract class ReceiveEvent extends Equatable {
  const ReceiveEvent();

  @override
  List<Object?> get props => [];
}

class ReceiveCasesEvent extends ReceiveEvent {
  final String date;
  final String time;
  final List<String> barcodes;

  const ReceiveCasesEvent({
    required this.date,
    required this.time,
    required this.barcodes,
  });

  @override
  List<Object?> get props => [date, time, barcodes];
}

class ReceiveAllCasesEvent extends ReceiveEvent {
  final int assignedId;

  const ReceiveAllCasesEvent({required this.assignedId});

  @override
  List<Object?> get props => [assignedId];
}
