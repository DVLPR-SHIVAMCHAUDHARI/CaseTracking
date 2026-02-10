import 'package:casetracking/features/recieve_cases/bloc/recieve_case_event.dart';
import 'package:casetracking/features/recieve_cases/bloc/recieve_case_state.dart';
import 'package:casetracking/features/recieve_cases/repo/recieve_case_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:casetracking/core/services/local_db.dart';

class ReceiveBloc extends Bloc<ReceiveEvent, ReceiveState> {
  final RecieveCaseRepository repo = RecieveCaseRepository();

  ReceiveBloc() : super(ReceiveInitial()) {
    on<ReceiveCasesEvent>(_onReceiveCases);
    on<ReceiveAllCasesEvent>(_onReceiveAllCases);
  }

  Future<void> _onReceiveCases(
    ReceiveCasesEvent event,
    Emitter<ReceiveState> emit,
  ) async {
    emit(ReceiveLoading());
    try {
      final stageId = await LocalDb.getStageId();

      final message = await repo.receiveCases(
        stageId: stageId!,
        date: event.date,
        time: event.time,
        barcodes: event.barcodes,
      );

      emit(ReceiveSuccess(message));
    } catch (e) {
      emit(ReceiveFailure(e.toString()));
    }
  }

  _onReceiveAllCases(
    ReceiveAllCasesEvent event,
    Emitter<ReceiveState> emit,
  ) async {
    emit(ReceiveAllCasesLoading());
    try {
      final message = await repo.receiveAllCases(assignedId: event.assignedId);
      emit(ReceiveAllCasesLoaded(message));
    } catch (e) {
      emit(ReceiveAllCasesFailure(e.toString()));
    }
  }
}
