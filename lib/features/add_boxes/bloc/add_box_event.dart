import 'package:equatable/equatable.dart';

abstract class AddBoxEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddNewBoxEvent extends AddBoxEvent {
  final String boxSize;
  final String barcode;

  AddNewBoxEvent(this.barcode, this.boxSize);

  @override
  List<Object?> get props => [boxSize, barcode];
}
