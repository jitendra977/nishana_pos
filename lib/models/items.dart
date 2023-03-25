class Item {
  String? name;
  int? price;
  int? qty;
  String? image;
  String? desc;
  String? barcode;

  Item({
    this.name,
    this.price,
    this.qty,
    this.image,
    this.desc,
    this.barcode,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'qty': qty,
      'image': image,
      'desc': desc,
      'barcode': barcode,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      price: json['price'],
      qty: json['qty'],
      image: json['image'],
      desc: json['desc'],
      barcode: json['barcode'],
    );
  }
}
