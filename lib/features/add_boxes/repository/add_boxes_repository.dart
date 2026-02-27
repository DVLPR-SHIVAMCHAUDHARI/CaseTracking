import 'package:casetracking/core/services/repository.dart';

class AddBoxesRepository extends Repository {
  addNewBoxes<String>({String? boxsize, String? barcode}) async {
    final result = await dio.post(
      "admin/create-barcode",
      data: {"barcode": barcode, "box_size": boxsize},
    );

    try {
      if (result.statusCode == 200) {
        if (result.data["Response"]["Status"]["StatusCode"] == "1") {
          throw result.data["Response"]["Status"]["DisplayText"];
        }
        return result.data["Response"]["Status"]["DisplayText"];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
