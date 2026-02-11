class PartyBoxModel {
  final int id;
  final String barcode;
  final String boxSize;
  final String createdAt;
  final String createdBy;
  final String partyName;
  final int boxSizeId;
  final int partyNameId;

  PartyBoxModel({
    required this.id,
    required this.barcode,
    required this.boxSize,
    required this.createdAt,
    required this.createdBy,
    required this.partyName,
    required this.boxSizeId,
    required this.partyNameId,
  });

  factory PartyBoxModel.fromJson(Map<String, dynamic> json) {
    return PartyBoxModel(
      id: json["id"] ?? 0,
      barcode: json["barcode"] ?? "",
      boxSize: json["box_size"] ?? "",
      createdAt: json["created_at"] ?? "",
      createdBy: json["created_by"] ?? "",
      partyName: json["party_name"] ?? "",
      boxSizeId: json["box_size_id"] ?? 0,
      partyNameId: json["party_name_id"] ?? 0,
    );
  }
}

class PartyWiseResponseModel {
  final List<PartyBoxModel> list;
  final int count;
  final bool error;
  final String code;

  PartyWiseResponseModel({
    required this.list,
    required this.count,
    required this.error,
    required this.code,
  });

  factory PartyWiseResponseModel.fromJson(Map<String, dynamic> json) {
    return PartyWiseResponseModel(
      list: (json["list"] as List)
          .map((e) => PartyBoxModel.fromJson(e))
          .toList(),
      count: json["count"] ?? 0,
      error: json["error"] ?? false,
      code: json["code"] ?? "",
    );
  }
}
