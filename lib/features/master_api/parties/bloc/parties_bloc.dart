import 'package:casetracking/features/master_api/parties/bloc/parties_event.dart';
import 'package:casetracking/features/master_api/parties/bloc/parties_state.dart';
import 'package:casetracking/features/master_api/repositories/masterrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartyBloc extends Bloc<PartyEvent, PartyState> {
  final MasterRepo repo;

  PartyBloc(this.repo) : super(PartyInitial()) {
    on<FetchParties>(_onFetch);
  }

  Future<void> _onFetch(FetchParties event, Emitter<PartyState> emit) async {
    emit(PartyLoading());
    try {
      final data = await repo.fetchParties();
      emit(PartyLoaded(data));
    } catch (e) {
      emit(PartyError(e.toString()));
    }
  }
}
