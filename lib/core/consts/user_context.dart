class UserContext {
  final String roleId;
  final String departmentId;

  UserContext({required this.roleId, required this.departmentId});

  /// ROLE
  bool get isAdmin => roleId == "2";
  bool get isStaff => roleId == "3";

  /// STAGES (ONLY FOR STAFF)
  bool get isStage1 => departmentId == "1";
  bool get isStage2 => departmentId == "2";
  bool get isStage3 => departmentId == "3";
}
