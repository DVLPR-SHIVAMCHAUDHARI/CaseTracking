import 'package:casetracking/core/services/repository.dart';
import 'package:casetracking/features/partyWiseReport/models/party_wise_case_remort_model.dart';

class PartyWiseRepository extends Repository {
  Future<PartyWiseResponseModel> getPartyBoxes({
    String? departmentId,
    String? partyName,
    String? barcode,
    String? boxSize,
    String? sortBy,
    String? orderBy,
    int offset = 1,
    int limit = 100,
  }) async {
    try {
      final response = await dio.get(
        'admin/get-party-boxes',
        queryParameters: {
          "department_id": departmentId ?? "",
          "party_name": partyName ?? "",
          "barcode": barcode ?? "",
          "box_size": boxSize ?? "",
          "sort_by": sortBy ?? "id",
          "order_by": orderBy ?? "asc",
          "offset": offset,
          "limit": limit,
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch party boxes");
      }

      final data = response.data;
      final statusCode = data["Response"]["Status"]["StatusCode"].toString();

      if (statusCode != "0") {
        throw Exception(
          data["Response"]["Status"]["ErrorMessage"] ?? "Unknown error",
        );
      }

      return PartyWiseResponseModel.fromJson(data["Response"]["ResponseData"]);
    } catch (e) {
      throw Exception("Error fetching party boxes: $e");
    }
  }
}
