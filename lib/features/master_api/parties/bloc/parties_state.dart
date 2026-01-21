import 'package:casetracking/features/master_api/models/party_model.dart';
import 'package:equatable/equatable.dart';

abstract class PartyState extends Equatable {
  const PartyState();

  @override
  List<Object?> get props => [];
}

class PartyInitial extends PartyState {}

class PartyLoading extends PartyState {}

class PartyLoaded extends PartyState {
  final List<PartyModel> parties;

  const PartyLoaded(this.parties);

  @override
  List<Object?> get props => [parties];
}

class PartyError extends PartyState {
  final String message;

  const PartyError(this.message);

  @override
  List<Object?> get props => [message];
}
