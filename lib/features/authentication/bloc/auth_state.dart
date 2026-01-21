import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends AuthState {
  final String message;
  LoginSuccessState({required this.message});
  @override
  List<Object?> get props => [message];
}

class LoginFailureState extends AuthState {
  final String error;
  LoginFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}

class LogoutState extends AuthState {
  @override
  List<Object?> get props => [];
}

/// ✅ UPDATE USER STATES
class UpdateUserLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class UpdateUserSuccessState extends AuthState {
  final String message;
  UpdateUserSuccessState({required this.message});
  @override
  List<Object?> get props => [message];
}

class UpdateUserFailureState extends AuthState {
  final String error;
  UpdateUserFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}

/// 🔐 UPDATE PASSWORD STATES
class UpdatePasswordLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class UpdatePasswordSuccessState extends AuthState {
  final String message;
  UpdatePasswordSuccessState({required this.message});
  @override
  List<Object?> get props => [message];
}

class UpdatePasswordFailureState extends AuthState {
  final String error;
  UpdatePasswordFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}
