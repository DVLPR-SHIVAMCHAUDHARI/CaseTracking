import 'package:casetracking/features/userList/bloc/user_list_event.dart';
import 'package:casetracking/features/userList/bloc/user_list_state.dart';
import 'package:casetracking/features/userList/repository/user_list_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserListRepo repo;

  UserListBloc({required this.repo}) : super(UserListInitial()) {
    on<FetchUserList>(_fetch);
  }

  Future<void> _fetch(FetchUserList event, Emitter<UserListState> emit) async {
    emit(UserListLoading());
    try {
      final users = await repo.fetchUserList(
        email: event.email,
        fullname: event.fullname,
        offset: event.offset,
        limit: event.limit,
      );

      if (users.isEmpty) {
        emit(UserListEmpty());
      } else {
        emit(UserListLoaded(users));
      }
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }
}
