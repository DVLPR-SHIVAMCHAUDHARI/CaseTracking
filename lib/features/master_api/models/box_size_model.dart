class BoxSizeModel {
  final int id;
  final int length;
  final int width;
  final int height;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  BoxSizeModel({
    required this.id,
    required this.length,
    required this.width,
    required this.height,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BoxSizeModel.fromJson(Map<String, dynamic> json) {
    return BoxSizeModel(
      id: json["id"],
      length: json["length"],
      width: json["width"],
      height: json["height"],
      isDeleted: json["is_deleted"] == 1,
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  /// UI helper (optional but very useful)
  String get label => "${length}×${width}×${height}";
}
