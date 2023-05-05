// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nishanapos/Services/Providers/CartProviders/GrandTotalProvider.dart';

class CartTable extends StatelessWidget {
  final String restaurantTable;
  final GrandTotalProvider grandTotalProvider;

  const CartTable({
    Key? key,
    required this.restaurantTable,
    required this.grandTotalProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = 0;
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("cart_items")
            .where('table_number', isEqualTo: restaurantTable)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found!');
          } else {
            List<TableRow> rows = [];

            snapshot.data!.docs.forEach((document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String itemName = data['itemName'];
              int itemPrice = data['price'];
              int qty = data['qty'];
              rows.add(_buildTableRow(
                  [itemName, qty, itemPrice, itemPrice * qty, "del"]));
              total += itemPrice * qty;
            });

            TableRow tableHeader =
                _buildTableRow(['Item', 'Qty', 'Price', 'Total', 'Action']);

            // Insert the new
            rows.insert(0, tableHeader);
            rows.add(_buildTableRow(['Grand Total', "", "", total, ""]));

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Table(
                  border: TableBorder.lerp(
                    TableBorder.all(width: 1.0, color: Colors.red),
                    TableBorder.all(width: 1.0, color: Colors.blue),
                    0.5,
                  ),
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                  },
                  children: rows,
                ),
              ),
            );
          }
        },
      ),
    );
    grandTotalProvider.updateGrandTotal(total);
  }

  static TableRow _buildTableRow(List<dynamic> data) {
    return TableRow(
      children: data
          .map((cellData) => Center(
                child: TableCell(
                  child: cellData is Icon
                      ? IconButton(icon: cellData, onPressed: () {})
                      : Text('$cellData'),
                ),
              ))
          .toList(),
    );
  }
}
