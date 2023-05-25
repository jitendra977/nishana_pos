class AddToCart {
  String? itemName;
  double? price;
  int? qty;
  String? tableNumber;
  String? date;
  String? userId;
  String? status;

  AddToCart(
      {this.itemName,
      this.price,
      this.qty,
      this.tableNumber,
      this.date,
      this.userId,
      this.status});

  AddToCart.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    price = json['price'];
    qty = json['qty'];
    tableNumber = json['table_number'];
    date = json['date'];
    userId = json['userId'];
    userId = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['table_number'] = this.tableNumber;
    data['date'] = this.date;
    data['userId'] = this.userId;
    data['status'] = 'none';
    return data;
  }
}
