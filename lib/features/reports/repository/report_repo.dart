import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/core/services/repository.dart';

class ReportRepo extends Repository {
  Future<List<Map<String, dynamic>>> fetchAssignedList({
    String? date,
    int? boxSize,
    int offset = 1,
    int limit = 10,
  }) async {
    /// department → action mapping
    final stageId = await LocalDb.getStageId();

    final action = stageId == '1'
        ? 'first_stage'
        : stageId == '2'
        ? 'second_stage'
        : null;

    final response = await dio.get(
      'staff/list-assigned',
      queryParameters: {
        'action': action,
        'date': date ?? '',
        'box_size': boxSize ?? '',
        'sort_by': '',
        'order_by': 'asc',
        'offset': offset,
        'limit': limit,
      },
    );

    final responseBody = response.data['Response'];
    final status = responseBody['Status'];

    if (status['StatusCode'] != '0') {
      throw status['DisplayText'] ?? 'Failed to fetch assigned list';
    }

    final List list = responseBody['ResponseData']['list'];

    return list.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchReceivedReports({
    String? fromDate,
    String? toDate,
    int? boxSizeId,
    int offset = 1,
    int limit = 10,
    String? orderBy,
  }) async {
    final stageId = await LocalDb.getStageId();

    final action = stageId == '1'
        ? 'first_stage'
        : stageId == '2'
        ? 'second_stage'
        : null;

    final response = await dio.get(
      "staff/list-received",
      queryParameters: {
        "action": action,
        "from_date": fromDate ?? "",
        "to_date": toDate ?? "",
        "box_size": boxSizeId ?? "",
        "sort_by": "",
        "order_by": orderBy ?? "asc",
        "offset": offset,
        "limit": limit,
      },
    );

    final res = response.data["Response"];
    final status = res["Status"];

    if (status["StatusCode"] != "0") {
      throw status["DisplayText"] ?? "Failed to fetch received reports";
    }

    final List list = res['ResponseData']['list'];

    return list.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchPendingToReceived({
    int? boxSizeId,
    int offset = 1,
    int limit = 10,
    String orderBy = "asc",
  }) async {
    final stageId = await LocalDb.getStageId();
    final action = stageId == '1'
        ? 'first_stage'
        : stageId == '2'
        ? 'second_stage'
        : null;

    final response = await dio.get(
      "staff/pending-to-received",
      queryParameters: {
        "action": action,
        "box_size": boxSizeId,
        "sort_by": "",
        "order_by": orderBy,
        "offset": offset,
        "limit": limit,
      },
    );

    final body = response.data["Response"];
    final status = body["Status"];

    if (status["StatusCode"] != "0") {
      throw status["DisplayText"] ?? "Failed to fetch pending batches";
    }

    final List list = body["ResponseData"]["list"];
    return list.cast<Map<String, dynamic>>();
  }
}
