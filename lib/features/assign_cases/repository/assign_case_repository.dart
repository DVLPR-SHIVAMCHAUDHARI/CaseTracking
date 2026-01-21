import 'package:casetracking/core/services/repository.dart';

class AssignCaseRepository extends Repository {
  Future<String> assignCasesStage2({
    required int locationId,
    required int partyId,
    required int boxSizeId,
    required String time,
    required String date,
    required List<String> barcodes,
  }) async {
    try {
      final response = await dio.post(
        "staff/assigned",
        data: {
          "location": locationId,
          "party_name": partyId,
          "box_size": boxSizeId,
          "time": time,
          "date": date,
          "barcode": barcodes,
          "action": "second_stage",
        },
      );

      final status = response.data["Response"]["Status"];

      if (status["StatusCode"] == "0") {
        return status["DisplayText"] ?? "Assigned successfully";
      } else {
        throw status["ErrorMessage"];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> assignStage1({
    required int locationId,
    required int boxSizeId,
    required String date,
    required String time,
    required List<String> barcodes,
  }) async {
    try {
      final response = await dio.post(
        "staff/assigned",
        data: {
          "location": locationId,
          "box_size": boxSizeId,
          "date": date,
          "time": time,
          "barcode": barcodes,
          "action": "first_stage",
        },
      );

      final status = response.data["Response"]["Status"];

      if (status["StatusCode"] == "0") {
        return status["DisplayText"];
      } else {
        throw status["ErrorMessage"];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future assignStage3({
    required int locationId,
    required int boxSizeId,
    required String date,
    required String time,
    required List<String> barcodes,
  }) async {
    try {
      final response = await dio.post(
        "staff/assigned",
        data: {
          "location": locationId,
          "box_size": boxSizeId,
          "date": date,
          "time": time,
          "barcode": barcodes,
          "action": "third_stage",
        },
      );

      final status = response.data["Response"]["Status"];

      if (status["StatusCode"] == "0") {
        return status["DisplayText"];
      } else {
        throw status["ErrorMessage"];
      }
    } catch (e) {
      rethrow;
    }
  }
}
