import 'package:casetracking/features/master_api/models/box_size_model.dart';
import 'package:equatable/equatable.dart';

abstract class BoxSizeState extends Equatable {
  const BoxSizeState();

  @override
  List<Object?> get props => [];
}

class BoxSizeInitial extends BoxSizeState {}

class BoxSizeLoading extends BoxSizeState {}

class BoxSizeLoaded extends BoxSizeState {
  final List<BoxSizeModel> sizes;

  const BoxSizeLoaded(this.sizes);

  @override
  List<Object?> get props => [sizes];
}

class BoxSizeError extends BoxSizeState {
  final String message;

  const BoxSizeError(this.message);

  @override
  List<Object?> get props => [message];
}
