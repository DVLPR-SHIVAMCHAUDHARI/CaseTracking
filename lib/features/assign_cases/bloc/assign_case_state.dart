import 'package:equatable/equatable.dart';

abstract class AssignCaseState extends Equatable {
  const AssignCaseState();

  @override
  List<Object?> get props => [];
}

class AssignCaseInitial extends AssignCaseState {}

class AssignCase2Loading extends AssignCaseState {}

class AssignCase2Success extends AssignCaseState {
  final String message;

  const AssignCase2Success({required this.message});

  @override
  List<Object?> get props => [message];
}

class AssignCase2Failure extends AssignCaseState {
  final String error;
  final List<String> failedBarcodes;

  const AssignCase2Failure({required this.error, required this.failedBarcodes});

  @override
  List<Object?> get props => [error, failedBarcodes];
}

class AssignCase1Loading extends AssignCaseState {}

class AssignCase1Success extends AssignCaseState {
  final String message;

  const AssignCase1Success({required this.message});

  @override
  List<Object?> get props => [message];
}

class AssignCase1Failure extends AssignCaseState {
  final String error;
  final List<String> failedBarcodes;

  const AssignCase1Failure({required this.error, required this.failedBarcodes});

  @override
  List<Object?> get props => [error, failedBarcodes];
}

class AssignCase3Loading extends AssignCaseState {}

class AssignCase3Success extends AssignCaseState {
  final String message;

  const AssignCase3Success({required this.message});

  @override
  List<Object?> get props => [message];
}

class AssignCase3Failure extends AssignCaseState {
  final String error;
  final List<String> failedBarcodes;

  const AssignCase3Failure({required this.error, required this.failedBarcodes});

  @override
  List<Object?> get props => [error, failedBarcodes];
}
