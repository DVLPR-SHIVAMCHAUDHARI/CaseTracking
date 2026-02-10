import 'package:equatable/equatable.dart';

abstract class ReceiveState extends Equatable {
  const ReceiveState();

  @override
  List<Object?> get props => [];
}

class ReceiveInitial extends ReceiveState {}

class ReceiveLoading extends ReceiveState {}

class ReceiveSuccess extends ReceiveState {
  final String message;

  const ReceiveSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ReceiveFailure extends ReceiveState {
  final String error;

  const ReceiveFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ReceiveAllCasesLoading extends ReceiveState {}

class ReceiveAllCasesLoaded extends ReceiveState {
  String message;

  ReceiveAllCasesLoaded(this.message);
  @override
  List<Object?> get props => [message];
}

class ReceiveAllCasesFailure extends ReceiveState {
  String error;

  ReceiveAllCasesFailure(this.error);
  @override
  List<Object?> get props => [error];
}
