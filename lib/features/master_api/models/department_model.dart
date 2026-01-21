class DepartmentModel {
  final int id;
  final String name;
  final bool isDeleted;
  final String createdAt;
  final String? updatedAt;
  final int createdBy;
  final int? updatedBy;
  final String createdByName;
  final String? updatedByName;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.createdByName,
    required this.updatedByName,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      name: json['name'],
      isDeleted: json['is_deleted'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdByName: json['created_by_name'],
      updatedByName: json['updated_by_name'],
    );
  }
}
