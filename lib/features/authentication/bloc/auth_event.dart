import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class UpdateUserEvent extends AuthEvent {
  final int id;
  final String fullname;
  final String email;
  final int departmentId;

  UpdateUserEvent({
    required this.id,
    required this.fullname,
    required this.email,
    required this.departmentId,
  });
  @override
  List<Object?> get props => [id, fullname, email, departmentId];
}

/// 🔐 UPDATE PASSWORD
class UpdatePasswordEvent extends AuthEvent {
  final int userId;
  final String newPassword;

  UpdatePasswordEvent({required this.userId, required this.newPassword});
  @override
  List<Object?> get props => [userId, newPassword];
}
