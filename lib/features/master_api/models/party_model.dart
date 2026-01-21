class PartyModel {
  final int id;
  final String name;
  final String companyAddress;
  final int boxLocation;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  PartyModel({
    required this.id,
    required this.name,
    required this.companyAddress,
    required this.boxLocation,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    return PartyModel(
      id: json['id'],
      name: json['name'],
      companyAddress: json['company_address'],
      boxLocation: int.parse(json['box_location'].toString()),
      isDeleted: json['is_deleted'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
