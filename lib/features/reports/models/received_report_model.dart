
class ReceivedReportModel {
  int? id;
  String? barcode;
  String? boxSize;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  String? receivedBy;
  String? receivedDate;
  String? receivedTime;
  int? stillAssigned;
  String? receivedLocation;

  ReceivedReportModel({this.id, this.barcode, this.boxSize, this.createdAt, this.createdBy, this.updatedAt, this.updatedBy, this.receivedBy, this.receivedDate, this.receivedTime, this.stillAssigned, this.receivedLocation});

  ReceivedReportModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["barcode"] is String) {
      barcode = json["barcode"];
    }
    if(json["box_size"] is String) {
      boxSize = json["box_size"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if(json["created_by"] is String) {
      createdBy = json["created_by"];
    }
    if(json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    if(json["updated_by"] is String) {
      updatedBy = json["updated_by"];
    }
    if(json["received_by"] is String) {
      receivedBy = json["received_by"];
    }
    if(json["received_date"] is String) {
      receivedDate = json["received_date"];
    }
    if(json["received_time"] is String) {
      receivedTime = json["received_time"];
    }
    if(json["still_assigned"] is int) {
      stillAssigned = json["still_assigned"];
    }
    if(json["received_location"] is String) {
      receivedLocation = json["received_location"];
    }
  }

  static List<ReceivedReportModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ReceivedReportModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["barcode"] = barcode;
    _data["box_size"] = boxSize;
    _data["created_at"] = createdAt;
    _data["created_by"] = createdBy;
    _data["updated_at"] = updatedAt;
    _data["updated_by"] = updatedBy;
    _data["received_by"] = receivedBy;
    _data["received_date"] = receivedDate;
    _data["received_time"] = receivedTime;
    _data["still_assigned"] = stillAssigned;
    _data["received_location"] = receivedLocation;
    return _data;
  }
}