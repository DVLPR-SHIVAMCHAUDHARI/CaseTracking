import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/core/services/repository.dart';

class ReceievePendingRepo extends Repository {
  Future<List<String>> fetchPendingBarcodes() async {
    final stage = await LocalDb.getStageId();
    final response = await dio.get(
      "staff/pending-barcode-received?action=${stage == '1'
          ? "first_stage"
          : stage == '2'
          ? "second_stage"
          : ""}", // 🔁 replace with actual endpoint
    );

    final responseBody = response.data["Response"];
    final status = responseBody["Status"];

    if (status["StatusCode"] != "0") {
      throw status["DisplayText"] ?? "Failed to fetch pending barcodes";
    }

    final List list = responseBody["ResponseData"]["barcodes"];

    return list.map((e) => e.toString()).toList();
  }
}
