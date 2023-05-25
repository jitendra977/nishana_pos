// ignore_for_file: dead_code
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widgets/table_popup.dart';

class CartTable extends StatelessWidget {
  final String restaurantTable;
  const CartTable({Key? key, required this.restaurantTable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("cart_items")
          .where('table_number', isEqualTo: restaurantTable)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        if (data.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No data available"),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('restaurant_table')
                        .where("table_name", isEqualTo: restaurantTable)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      querySnapshot.docs.forEach((DocumentSnapshot doc) {
                        doc.reference.update({'status': 'Available'});
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Clean Table"),
                ),
              ],
            ),
          );
        }

        double grandTotal = data.docs.fold(0.0, (total, item) {
          return total + (item['qty'] * item['price']);
        });

        return SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  color: Color.fromARGB(255, 85, 66, 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => TablePopup());
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Text(
                                  restaurantTable,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 253, 250, 250),
                                    fontSize: 20,
                                    backgroundColor:
                                        Color.fromARGB(255, 33, 33, 33),
                                  ),
                                ),
                                Icon(
                                  Icons.swap_horiz,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "Bill :ADDJ55",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        Text(
                          "Rs ${grandTotal.toString()}",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Color.fromARGB(255, 48, 4, 143)),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(1.4),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1.5),
                      },
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: Colors.black),
                        outside: BorderSide(color: Colors.black),
                      ),
                      children: [
                        _buildTableHeaderRow(),
                        ...data.docs.map((item) => _buildTableRow(item)),
                        _buildGrandTotalRow(grandTotal.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

TableRow _buildTableHeaderRow() {
  return TableRow(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      border: Border(
        bottom: BorderSide(color: Colors.black),
      ),
    ),
    children: [
      _buildTableHeaderCell('Item Name'),
      _buildTableHeaderCell('Price'),
      _buildTableHeaderCell('Qty'),
      _buildTableHeaderCell('Total'),
    ],
  );
}

Widget _buildTableHeaderCell(String text) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

TableRow _buildTableRow(DocumentSnapshot item) {
  IconData getStatusIcon(String status) {
    switch (status) {
      case 'saved':
        return Icons.fireplace_rounded;
      case 'cooking':
        return Icons.restaurant_menu;
      case 'ready':
        return Icons.check_circle;
      case 'none':
        return Icons.access_alarm;
      default:
        return Icons.done_all;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'saved':
        return Color.fromARGB(255, 111, 0, 255);
      case 'cooking':
        return Colors.red;
      case 'ready':
        return Colors.green;
      case 'none':
        return Colors.black87;
      default:
        return Colors.grey;
    }
  }

  return TableRow(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.red),
      ),
    ),
    children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(
                getStatusIcon(item['status']),
                color: getStatusColor(item['status']),
              ),
              SizedBox(width: 5),
              Text(
                item['itemName'],
                style: TextStyle(color: getStatusColor(item['status'])),
              ),
            ],
          ),
        ),
      ),
      TableCell(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            item['price'].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      TableCell(
        child: Center(
          heightFactor: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  if (item['qty'] <= 1) {
                    await FirebaseFirestore.instance
                        .collection('cart_items')
                        .doc(item.id)
                        .delete();
                  } else {
                    final currentQty = item['qty'];
                    FirebaseFirestore.instance
                        .collection("cart_items")
                        .doc(item.id)
                        .update({"qty": currentQty - 1}).catchError(
                            (e) => print(e));
                  }
                },
                child: _buildQuantityButton(Icons.remove, Colors.red),
              ),
              Text(
                '  ${item['qty'].toString()}  ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  final currentQty = item['qty'];
                  FirebaseFirestore.instance
                      .collection("cart_items")
                      .doc(item.id)
                      .update({"qty": currentQty + 1}).catchError(
                          (e) => print(e));
                },
                child: _buildQuantityButton(Icons.add, Colors.blue),
              ),
            ],
          ),
        ),
      ),
      TableCell(
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              (item['qty'] * item['price']).toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ],
  );
}

TableRow _buildGrandTotalRow(String grandtotal) {
  return TableRow(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      border: Border(
        top: BorderSide(color: Colors.black),
      ),
    ),
    children: [
      _buildTableHeaderCell('Grand Total'),
      const TableCell(child: SizedBox()),
      TableCell(
        child: Text(
          "       Rs.",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      TableCell(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            grandtotal.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}

Widget _buildQuantityButton(IconData icon, Color color) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      color: color,
    ),
    child: Icon(
      icon,
      color: Colors.white,
    ),
  );
}
