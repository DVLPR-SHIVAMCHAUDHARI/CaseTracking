import 'package:equatable/equatable.dart';

abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserList extends UserListEvent {
  final String email;
  final String fullname;
  final int offset;
  final int limit;

  const FetchUserList({
    this.email = "",
    this.fullname = "",
    this.offset = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [email, fullname, offset, limit];
}
