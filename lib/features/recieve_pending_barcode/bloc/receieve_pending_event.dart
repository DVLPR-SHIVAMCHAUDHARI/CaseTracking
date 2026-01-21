import 'package:equatable/equatable.dart';

abstract class PendingBarcodeEvent extends Equatable {
  const PendingBarcodeEvent();

  @override
  List<Object?> get props => [];
}

class FetchPendingBarcodes extends PendingBarcodeEvent {
  const FetchPendingBarcodes();
}
