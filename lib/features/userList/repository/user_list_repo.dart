import 'package:casetracking/core/consts/globals.dart';
import 'package:casetracking/core/services/repository.dart';
import 'package:casetracking/features/userList/models/user_model.dart';

class UserListRepo extends Repository {
  Future<List<UserModel>> fetchUserList({
    String email = "",
    String fullname = "",
    String sortBy = "id",
    String orderBy = "asc",
    int offset = 1,
    int limit = 10,
  }) async {
    final response = await dio.get(
      "user/user-list",
      queryParameters: {
        "email": email,
        "fullname": fullname,
        "sort_by": sortBy,
        "order_by": orderBy,
        "offset": offset,
        "limit": limit,
      },
    );
    final body = response.data["Response"];
    final status = body["Status"]["StatusCode"];

    if (status != "0") {
      throw body["Status"]["DisplayText"];
    }

    final List list = body["ResponseData"]["list"];
    ;

    return list.map((e) => UserModel.fromJson(e)).toList();
  }
}
