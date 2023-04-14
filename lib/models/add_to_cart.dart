class AddToCart {
  String? itemName;
  int? price;
  int? qty;
  String? tableNumber;
  String? date;
  String? userId;

  AddToCart(
      {this.itemName,
      this.price,
      this.qty,
      this.tableNumber,
      this.date,
      this.userId});

  AddToCart.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    price = json['price'];
    qty = json['qty'];
    tableNumber = json['table_number'];
    date = json['date'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['table_number'] = this.tableNumber;
    data['date'] = this.date;
    data['userId'] = this.userId;
    return data;
  }
}
