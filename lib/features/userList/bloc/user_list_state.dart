import 'package:casetracking/features/userList/models/user_model.dart';

import 'package:equatable/equatable.dart';

abstract class UserListState extends Equatable {
  const UserListState();

  @override
  List<Object?> get props => [];
}

/// INITIAL
class UserListInitial extends UserListState {}

/// LOADING
class UserListLoading extends UserListState {}

/// SUCCESS
class UserListLoaded extends UserListState {
  final List<UserModel> users;

  const UserListLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

/// EMPTY
class UserListEmpty extends UserListState {}

/// ERROR
class UserListError extends UserListState {
  final String message;

  const UserListError(this.message);

  @override
  List<Object?> get props => [message];
}
