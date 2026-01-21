import 'package:casetracking/core/consts/globals.dart';
import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/core/services/repository.dart';
import 'package:casetracking/core/services/token_service.dart';

class AuthRepo extends Repository {
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "user/login",
        data: {"email": username, "password": password},
      );

      final responseBody = response.data["Response"];
      final status = responseBody["Status"];
      final statusCode = status["StatusCode"];
      final message = status["DisplayText"];

      if (statusCode != "0") {
        return message;
      }

      final data = responseBody["ResponseData"];

      await TokenServices().storeTokens(accessToken: data["x_auth_token"]);

      await LocalDb.saveUser(
        userId: data["user_id"].toString(),
        username: data["fullname"],
        departmentId: data["department_id"].toString(),
        roleId: data["role_id"].toString(),
      );

      return message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateUser({
    required int id,
    required String fullname,
    required String email,
    required int departmentId,
  }) async {
    final response = await dio.post(
      "user/update",
      data: {
        "id": id,
        "fullname": fullname,
        "email": email,
        "department_id": departmentId,
      },
    );

    final status = response.data["Response"]["Status"];

    if (status["StatusCode"] == "0") {
      return status["DisplayText"];
    } else {
      throw status["DisplayText"];
    }
  }

  Future<String> updatePassword({
    required int updatedUserId,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "user/update-password",
        data: {"updated_user_id": updatedUserId, "password": password},
      );

      final status = response.data["Response"]["Status"];

      if (status["StatusCode"] == "0") {
        return status["DisplayText"]; // Success message
      } else {
        return status["DisplayText"]; // Failure message
      }
    } catch (e) {
      throw Exception("Unable to update password");
    }
  }
}
