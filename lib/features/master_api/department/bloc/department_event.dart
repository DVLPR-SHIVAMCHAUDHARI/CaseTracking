import 'package:equatable/equatable.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();

  @override
  List<Object?> get props => [];
}

class FetchDepartments extends DepartmentEvent {
  const FetchDepartments();
}
