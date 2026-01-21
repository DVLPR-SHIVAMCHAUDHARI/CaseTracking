import 'package:equatable/equatable.dart';

abstract class PendingBarcodeState extends Equatable {
  const PendingBarcodeState();

  @override
  List<Object?> get props => [];
}

class PendingBarcodeInitial extends PendingBarcodeState {}

class PendingBarcodeLoading extends PendingBarcodeState {}

class PendingBarcodeLoaded extends PendingBarcodeState {
  final List<String> barcodes;

  const PendingBarcodeLoaded(this.barcodes);

  @override
  List<Object?> get props => [barcodes];
}

class PendingBarcodeError extends PendingBarcodeState {
  final String message;

  const PendingBarcodeError(this.message);

  @override
  List<Object?> get props => [message];
}
