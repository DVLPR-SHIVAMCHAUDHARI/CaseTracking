import 'package:equatable/equatable.dart';

abstract class BoxSizeEvent extends Equatable {
  const BoxSizeEvent();

  @override
  List<Object?> get props => [];
}

class FetchBoxSizes extends BoxSizeEvent {
  const FetchBoxSizes();
}
