import 'package:casetracking/features/reports/models/assigned_model.dart';

class PendingToReceivedBatch {
  final int id;
  final String date;
  final String time;
  final int boxSizeId;
  final int locationId;
  final String createdAt;
  final String createdBy;
  final String locationName;
  final List<String> barcodes;
  final BoxSizeDetails boxSizeDetails;

  PendingToReceivedBatch({
    required this.id,
    required this.date,
    required this.time,
    required this.boxSizeId,
    required this.locationId,
    required this.createdAt,
    required this.createdBy,
    required this.locationName,
    required this.barcodes,
    required this.boxSizeDetails,
  });

  factory PendingToReceivedBatch.fromJson(Map<String, dynamic> json) {
    return PendingToReceivedBatch(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      boxSizeId: json['box_size'],
      locationId: json['location'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      locationName: json['location_name'],
      barcodes: (json['barcode_boxes'] as List)
          .map((e) => e['barcode'].toString())
          .toList(),
      boxSizeDetails: BoxSizeDetails.fromJson(json['box_size_details']),
    );
  }
}
