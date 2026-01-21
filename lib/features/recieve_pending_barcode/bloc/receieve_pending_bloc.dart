import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_event.dart';
import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_state.dart';
import 'package:casetracking/features/recieve_pending_barcode/repo/receieve_Pending_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingBarcodeBloc
    extends Bloc<PendingBarcodeEvent, PendingBarcodeState> {
  final ReceievePendingRepo repo = ReceievePendingRepo();

  PendingBarcodeBloc() : super(PendingBarcodeInitial()) {
    on<FetchPendingBarcodes>(_onFetchPendingBarcodes);
  }

  Future<void> _onFetchPendingBarcodes(
    FetchPendingBarcodes event,
    Emitter<PendingBarcodeState> emit,
  ) async {
    emit(PendingBarcodeLoading());

    try {
      final barcodes = await repo.fetchPendingBarcodes();
      emit(PendingBarcodeLoaded(barcodes));
    } catch (e) {
      emit(PendingBarcodeError(e.toString()));
    }
  }
}
