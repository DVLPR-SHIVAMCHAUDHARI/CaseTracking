import 'package:casetracking/features/master_api/repositories/masterrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'box_size_event.dart';
import 'box_size_state.dart';

class BoxSizeBloc extends Bloc<BoxSizeEvent, BoxSizeState> {
  final MasterRepo repo;

  BoxSizeBloc(this.repo) : super(BoxSizeInitial()) {
    on<FetchBoxSizes>(_onFetch);
  }

  Future<void> _onFetch(FetchBoxSizes event, Emitter<BoxSizeState> emit) async {
    emit(BoxSizeLoading());
    try {
      final data = await repo.fetchBoxSizes();
      emit(BoxSizeLoaded(data));
    } catch (e) {
      emit(BoxSizeError(e.toString()));
    }
  }
}
