class RestaurantTable {
  String? tableName;
  String? priority;
  String? floor;
  String? status;

  RestaurantTable({
    this.tableName,
    this.priority,
    this.floor,
    this.status,
  });

  RestaurantTable.fromJson(Map<String, dynamic> json) {
    tableName = json['table_name'];
    priority = json['priority'];
    floor = json['floor'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['table_name'] = this.tableName;
    data['priority'] = this.priority;
    data['floor'] = this.floor;
    data['status'] = this.status;
    return data;
  }
}
