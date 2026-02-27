import 'package:casetracking/features/add_boxes/bloc/add_box_event.dart';
import 'package:casetracking/features/add_boxes/bloc/add_box_state.dart';
import 'package:casetracking/features/add_boxes/repository/add_boxes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBoxBloc extends Bloc<AddBoxEvent, AddBoxState> {
  AddBoxesRepository repo = AddBoxesRepository();
  AddBoxBloc() : super(InitialState()) {
    on<AddNewBoxEvent>(addNewBox);
  }

  addNewBox(AddNewBoxEvent event, Emitter emit) async {
    emit(AddNewBoxLoadingState());
    try {
      String result = await repo.addNewBoxes(
        barcode: event.barcode,
        boxsize: event.boxSize,
      );
      emit(AddNewBoxSuccessState(result));
    } catch (e) {
      emit(AddNewBoxFailureState(e.toString()));
    }
  }
}
