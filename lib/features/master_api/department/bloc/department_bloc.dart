import 'package:casetracking/features/master_api/repositories/masterrepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'department_event.dart';
import 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final MasterRepo repo;

  DepartmentBloc(this.repo) : super(DepartmentInitial()) {
    on<FetchDepartments>(_onFetch);
  }

  Future<void> _onFetch(
    FetchDepartments event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      final data = await repo.fetchDepartments();
      emit(DepartmentLoaded(data));
    } catch (e) {
      emit(DepartmentError(e.toString()));
    }
  }
}
