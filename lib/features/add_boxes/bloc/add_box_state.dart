import 'package:equatable/equatable.dart';

abstract class AddBoxState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends AddBoxState {}

class AddNewBoxLoadingState extends AddBoxState {}

class AddNewBoxSuccessState extends AddBoxState {
  final String message;
  AddNewBoxSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class AddNewBoxFailureState extends AddBoxState {
  final String error;
  AddNewBoxFailureState(this.error);
  @override
  List<Object?> get props => [error];
}
