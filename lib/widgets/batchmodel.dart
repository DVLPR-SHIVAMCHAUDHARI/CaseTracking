class BatchReport {
  final String batchId;
  final String title; // e.g. Renuka → Faridabad
  final int quantity;
  final DateTime dateTime;
  final String location;
  final String operation; // assign / receive
  final List<String> barcodes;

  BatchReport({
    required this.batchId,
    required this.title,
    required this.quantity,
    required this.dateTime,
    required this.location,
    required this.operation,
    required this.barcodes,
  });
}
