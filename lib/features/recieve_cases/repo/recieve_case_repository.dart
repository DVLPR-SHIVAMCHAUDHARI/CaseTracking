import 'package:casetracking/core/services/repository.dart';

class RecieveCaseRepository extends Repository {
  Future<String> receiveCases({
    required String departmentId, // from LocalDb or auth
    required String date,
    required String time,
    required List<String> barcodes,
  }) async {
    /// 🔹 Decide action based on department
    final String action = departmentId == '1'
        ? 'first_stage'
        : departmentId == '2'
        ? 'second_stage'
        : 'third_stage';

    final response = await dio.post(
      'staff/received',
      data: {"date": date, "time": time, "barcode": barcodes, "action": action},
    );

    final status = response.data["Response"]["Status"];

    if (status["StatusCode"] == "0") {
      return status["DisplayText"] ?? "Cases received successfully";
    } else {
      throw status["ErrorMessage"] ?? "Receiving cases failed";
    }
  }
}
