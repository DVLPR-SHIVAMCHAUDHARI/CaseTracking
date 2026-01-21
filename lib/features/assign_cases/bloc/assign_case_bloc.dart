import 'package:bloc/bloc.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_event.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_state.dart';
import 'package:casetracking/features/assign_cases/repository/assign_case_repository.dart';

class AssignCaseBloc extends Bloc<AssignCaseEvent, AssignCaseState> {
  final AssignCaseRepository repo;

  AssignCaseBloc(this.repo) : super(AssignCaseInitial()) {
    on<AssignCasesStage2Event>(_onAssignStage2);
    on<AssignCasesStage1Event>(_assignStage1);
    on<AssignCasesStage3Event>(_assignStage3);
  }

  Future<void> _onAssignStage2(
    AssignCasesStage2Event event,
    Emitter<AssignCaseState> emit,
  ) async {
    emit(AssignCase2Loading());

    try {
      final message = await repo.assignCasesStage2(
        locationId: event.locationId,
        partyId: event.partyId,
        boxSizeId: event.boxSizeId,
        date: event.date,
        time: event.time,
        barcodes: List<String>.from(event.barcodes),
      );

      emit(AssignCase2Success(message: message));
    } catch (e) {
      final error = e.toString();

      emit(
        AssignCase2Failure(
          error: error,
          failedBarcodes: extractBarcodesFromError(error),
        ),
      );
    }
  }

  Future<void> _assignStage1(
    AssignCasesStage1Event event,
    Emitter<AssignCaseState> emit,
  ) async {
    emit(AssignCase1Loading());
    try {
      final message = await repo.assignStage1(
        locationId: event.locationId,
        boxSizeId: event.boxSizeId,
        date: event.date,
        time: event.time,
        barcodes: event.barcodes,
      );
      emit(AssignCase1Success(message: message));
    } catch (e) {
      final error = e.toString();

      emit(
        AssignCase1Failure(
          error: error,
          failedBarcodes: extractBarcodesFromError(error),
        ),
      );
    }
  }

  Future<void> _assignStage3(
    AssignCasesStage3Event event,
    Emitter<AssignCaseState> emit,
  ) async {
    emit(AssignCase3Loading());
    try {
      final message = await repo.assignStage3(
        locationId: event.locationId,
        boxSizeId: event.boxSizeId,
        date: event.date,
        time: event.time,
        barcodes: event.barcodes,
      );
      emit(AssignCase3Success(message: message));
    } catch (e) {
      final error = e.toString();
      emit(
        AssignCase3Failure(
          error: error,
          failedBarcodes: extractBarcodesFromError(error),
        ),
      );
    }
  }
}

List<String> extractBarcodesFromError(String message) {
  final match = RegExp(r'\[(.*?)\]').firstMatch(message);
  if (match == null) return [];

  final content = match.group(1)!;
  return content.split(',').map((e) => e.trim()).toList();
}
