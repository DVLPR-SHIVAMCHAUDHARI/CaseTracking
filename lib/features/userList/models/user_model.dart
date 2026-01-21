
class UserModel {
  int? id;
  String? email;
  String? roleId;
  String? fullname;
  String? roleName;
  String? createdAt;
  String? createdBy;
  int? isDeleted;
  String? updatedAt;
  dynamic updatedBy;
  int? isVerified;
  int? departmentId;
  String? departmentName;

  UserModel({this.id, this.email, this.roleId, this.fullname, this.roleName, this.createdAt, this.createdBy, this.isDeleted, this.updatedAt, this.updatedBy, this.isVerified, this.departmentId, this.departmentName});

  UserModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["role_id"] is String) {
      roleId = json["role_id"];
    }
    if(json["fullname"] is String) {
      fullname = json["fullname"];
    }
    if(json["role_name"] is String) {
      roleName = json["role_name"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if(json["created_by"] is String) {
      createdBy = json["created_by"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    updatedBy = json["updated_by"];
    if(json["is_verified"] is int) {
      isVerified = json["is_verified"];
    }
    if(json["department_id"] is int) {
      departmentId = json["department_id"];
    }
    if(json["department_name"] is String) {
      departmentName = json["department_name"];
    }
  }

  static List<UserModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["email"] = email;
    _data["role_id"] = roleId;
    _data["fullname"] = fullname;
    _data["role_name"] = roleName;
    _data["created_at"] = createdAt;
    _data["created_by"] = createdBy;
    _data["is_deleted"] = isDeleted;
    _data["updated_at"] = updatedAt;
    _data["updated_by"] = updatedBy;
    _data["is_verified"] = isVerified;
    _data["department_id"] = departmentId;
    _data["department_name"] = departmentName;
    return _data;
  }
}