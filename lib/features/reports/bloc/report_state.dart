import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class AssignedReportInitial extends ReportState {}

class AssignedReportLoading extends ReportState {}

class AssignedReportLoaded extends ReportState {
  final List<Map<String, dynamic>> reports;
  final bool hasMore;

  const AssignedReportLoaded({required this.reports, required this.hasMore});
  @override
  List<Object?> get props => [reports, hasMore];
}

class AssignedReportError extends ReportState {
  final String message;

  const AssignedReportError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReceivedReportLoading extends ReportState {}

class ReceivedReportLoaded extends ReportState {
  final List<Map<String, dynamic>> reports;
  final bool hasMore;

  const ReceivedReportLoaded({required this.reports, required this.hasMore});
  @override
  List<Object?> get props => [reports, hasMore];
}

class ReceivedReportError extends ReportState {
  final String message;
  const ReceivedReportError(this.message);
  @override
  List<Object?> get props => [message];
}

class PendingToReceivedLoading extends ReportState {}

class PendingToReceivedLoaded extends ReportState {
  final List<Map<String, dynamic>> reports;
  final bool hasMore;

  const PendingToReceivedLoaded({required this.reports, required this.hasMore});

  @override
  List<Object?> get props => [reports, hasMore];
}

class PendingToReceivedError extends ReportState {
  final String message;

  const PendingToReceivedError(this.message);

  @override
  List<Object?> get props => [message];
}
