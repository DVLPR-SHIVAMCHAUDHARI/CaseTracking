class UserContext {
  final String roleId;
  final String stageId;

  UserContext({required this.roleId, required this.stageId});

  /// ROLE
  bool get isAdmin => roleId == "2";
  bool get isStaff => roleId == "3";

  /// STAGES (ONLY FOR STAFF)
  bool get isStage1 => stageId == "1";
  bool get isStage2 => stageId == "2";
  bool get isStage3 => stageId == "3";
}
