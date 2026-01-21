class AssignedBatch {
  final int id;
  final String date;
  final String time;
  final String locationName;
  final String createdBy;
  final List<String> barcodes;
  final BoxSizeDetails boxSize;

  AssignedBatch({
    required this.id,
    required this.date,
    required this.time,
    required this.locationName,
    required this.createdBy,
    required this.barcodes,
    required this.boxSize,
  });

  factory AssignedBatch.fromJson(Map<String, dynamic> json) {
    return AssignedBatch(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      locationName: json['location_name'],
      createdBy: json['created_by'],
      barcodes: (json['barcode_boxes'] as List)
          .map((e) => e['barcode'].toString())
          .toList(),
      boxSize: BoxSizeDetails.fromJson(json['box_size_details']),
    );
  }
}

class BoxSizeDetails {
  final int width;
  final int height;
  final int length;

  BoxSizeDetails({
    required this.width,
    required this.height,
    required this.length,
  });

  factory BoxSizeDetails.fromJson(Map<String, dynamic> json) {
    return BoxSizeDetails(
      width: json['width'],
      height: json['height'],
      length: json['length'],
    );
  }
}
