import 'package:equatable/equatable.dart';

abstract class PartyEvent extends Equatable {
  const PartyEvent();

  @override
  List<Object?> get props => [];
}

class FetchParties extends PartyEvent {
  const FetchParties();
}
