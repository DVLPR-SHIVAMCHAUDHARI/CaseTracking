import 'package:casetracking/core/services/repository.dart';
import 'package:casetracking/features/authentication/Screens/update_user.dart';
import 'package:casetracking/features/master_api/models/box_size_model.dart';
import 'package:casetracking/features/master_api/models/department_model.dart';
import 'package:casetracking/features/master_api/models/party_model.dart';

class MasterRepo extends Repository {
  Future<List<DepartmentModel>> fetchDepartments() async {
    final response = await dio.get("/common/get-department");

    final responseBody = response.data["Response"];
    final status = responseBody["Status"];

    if (status["StatusCode"] != "0") {
      throw status["DisplayText"] ?? "Failed to fetch departments";
    }

    final List list = responseBody["ResponseData"]["mst_department"] as List;

    return list
        .map((e) => DepartmentModel.fromJson(e))
        .where((d) => !d.isDeleted)
        .toList();
  }

  Future<List<BoxSizeModel>> fetchBoxSizes() async {
    final response = await dio.get("/common/get-size");

    final responseBody = response.data["Response"];
    final status = responseBody["Status"];

    if (status["StatusCode"] != "0") {
      throw status["DisplayText"] ?? "Failed to fetch box sizes";
    }

    final List list = responseBody["ResponseData"]["mst_box_size"] as List;

    return list
        .map((e) => BoxSizeModel.fromJson(e))
        .where((b) => !b.isDeleted)
        .toList();
  }

  Future<List<PartyModel>> fetchParties() async {
    final response = await dio.get("/common/get-party");

    final responseBody = response.data["Response"];
    final status = responseBody["Status"];

    if (status["StatusCode"] != "0") {
      throw status["DisplayText"] ?? "Failed to fetch parties";
    }

    final List list = responseBody["ResponseData"]["mst_box_Party"] as List;

    return list
        .map((e) => PartyModel.fromJson(e))
        .where((e) => !e.isDeleted!)
        .toList();
  }
}
