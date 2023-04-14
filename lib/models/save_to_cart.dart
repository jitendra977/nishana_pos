import 'dart:convert';

class SaveCart {
  String item_name;
  int price;
  int qty;
  String table_name;
  String bill_no;
  SaveCart({
    required this.item_name,
    required this.price,
    required this.qty,
    required this.table_name,
    required this.bill_no,
  });

  SaveCart copyWith({
    String? item_name,
    int? price,
    int? qty,
    String? table_name,
    String? bill_no,
  }) {
    return SaveCart(
      item_name: item_name ?? this.item_name,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      table_name: table_name ?? this.table_name,
      bill_no: bill_no ?? this.bill_no,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'item_name': item_name});
    result.addAll({'price': price});
    result.addAll({'qty': qty});
    result.addAll({'table_name': table_name});
    result.addAll({'bill_no': bill_no});

    return result;
  }

  factory SaveCart.fromMap(Map<String, dynamic> map) {
    return SaveCart(
      item_name: map['item_name'] ?? '',
      price: map['price']?.toInt() ?? 0,
      qty: map['qty']?.toInt() ?? 0,
      table_name: map['table_name'] ?? '',
      bill_no: map['bill_no'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveCart.fromJson(String source) =>
      SaveCart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SaveCart(item_name: $item_name, price: $price, qty: $qty, table_name: $table_name, bill_no: $bill_no)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SaveCart &&
        other.item_name == item_name &&
        other.price == price &&
        other.qty == qty &&
        other.table_name == table_name &&
        other.bill_no == bill_no;
  }

  @override
  int get hashCode {
    return item_name.hashCode ^
        price.hashCode ^
        qty.hashCode ^
        table_name.hashCode ^
        bill_no.hashCode;
  }
}
