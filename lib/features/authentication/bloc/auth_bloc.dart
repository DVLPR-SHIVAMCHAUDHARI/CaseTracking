import 'package:bloc/bloc.dart';
import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/core/services/token_service.dart';
import 'package:casetracking/features/authentication/bloc/auth_event.dart';
import 'package:casetracking/features/authentication/bloc/auth_state.dart';
import 'package:casetracking/features/authentication/repository/auth_repo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<UpdateUserEvent>(_onUpdateUser);
    on<UpdatePasswordEvent>(_onUpdatePassword);
  }

  _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      final authRepo = AuthRepo();
      final result = await authRepo.login(
        username: event.username,
        password: event.password,
      );

      emit(LoginSuccessState(message: result));
    } catch (e) {
      emit(LoginFailureState(error: e.toString()));
    }
  }

  _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    final tokenService = TokenServices();
    await tokenService.clear();
    await LocalDb.clear();
    emit(LogoutState());
  }

  /// ✅ UPDATE USER
  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(UpdateUserLoadingState());
    try {
      final authRepo = AuthRepo();

      final message = await authRepo.updateUser(
        id: event.id,
        fullname: event.fullname,
        email: event.email,
        departmentId: event.departmentId,
      );

      emit(UpdateUserSuccessState(message: message));
    } catch (e) {
      emit(UpdateUserFailureState(error: e.toString()));
    }
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(UpdatePasswordLoadingState());

    try {
      final repo = AuthRepo();

      final message = await repo.updatePassword(
        updatedUserId: event.userId,
        password: event.newPassword,
      );

      if (message.toLowerCase().contains("success")) {
        emit(UpdatePasswordSuccessState(message: message));
      } else {
        emit(UpdatePasswordFailureState(error: message));
      }
    } catch (_) {
      emit(UpdatePasswordFailureState(error: "Failed to update password"));
    }
  }
}
