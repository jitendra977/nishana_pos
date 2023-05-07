// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nishanapos/Services/Providers/CartProviders/GrandTotalProvider.dart';
import 'package:provider/provider.dart';

import '../../../models/add_to_cart.dart';

class CartTable extends StatelessWidget {
  final String restaurantTable;
  const CartTable({Key? key, required this.restaurantTable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("cart_items").where('table_number',isEqualTo: restaurantTable).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        if (data.docs.isEmpty) {
          return const Center(child: Text("No data available"));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
                4: FixedColumnWidth(30),
              },
              border: TableBorder.all(width: 1.0, color: Colors.red),
              children: [
                const TableRow(
                  decoration: BoxDecoration(boxShadow: []),
                  children: [
                    TableCell(
                      child: IntrinsicWidth(
                        child: Text(
                          'Item Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Text(
                          'Qty',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const TableCell(
                        child: SizedBox()), // empty cell for spacing
                  ],
                ),
                ...data.docs.map((item) => TableRow(
                      children: [
                        TableCell(
                          child: IntrinsicWidth(
                            child: Text(item['itemName'].toString()),
                          ),
                        ),
                        TableCell(
                          child: Center(child: Text(item['qty'].toString())),
                        ),
                        TableCell(
                          child: Text(item['price'].toString()),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              (item['qty'] * item['price']).toString(),
                            ),
                          ),
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('cart_items')
                                  .doc(item.id)
                                  .delete();
                              final grandTotalProvider =
                                  Provider.of<GrandTotalProvider>(context,
                                      listen: false);
                              grandTotalProvider.updateGrandTotal();
                            },
                            child: const Icon(Icons.delete),
                          ),
                        ),
                      ],
                    )),
                TableRow(
                  children: [
                    const TableCell(child: SizedBox()),
                    const TableCell(child: SizedBox()),
                    const TableCell(child: Text("GTotal")),
                    TableCell(
                      child: Consumer<GrandTotalProvider>(
                        builder: (BuildContext context, grandTotalProvider,
                            Widget? child) {
                          return Text(
                            '${grandTotalProvider.grandTotal.toString()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    const TableCell(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class ShowItems extends StatelessWidget {
  final String selectedCategoryName;
  final User? userId = FirebaseAuth.instance.currentUser;

  ShowItems({required this.selectedCategoryName});

  @override
  Widget build(BuildContext context) => Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("menu_items")
              .where("category", isEqualTo: selectedCategoryName)
              .snapshots(),
          builder: (context, snapshot) => snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final name = doc['item_name'],
                        category = doc['category'],
                        image = doc['img_url'],
                        price = doc['price'];

                    void saveToCart() async {
                      final cartItems = await FirebaseFirestore.instance
                          .collection("cart_items")
                          .where("itemName", isEqualTo: name)
                          .where("userId", isEqualTo: userId?.uid)
                          .get();

                      if (cartItems.docs.isEmpty) {
                        FirebaseFirestore.instance
                            .collection("cart_items")
                            .doc()
                            .set(AddToCart(
                                    itemName: name,
                                    date: DateTime.now().toString(),
                                    price: int.tryParse(price),
                                    qty: 1,
                                    userId: userId?.uid,
                                    tableNumber: "Table1")
                                .toJson())
                            .catchError((e) => print(e));
                      } else {
                        final cartItem = cartItems.docs.first;
                        final currentQty = cartItem['qty'];
                        FirebaseFirestore.instance
                            .collection("cart_items")
                            .doc(cartItem.id)
                            .update({"qty": currentQty + 1}).catchError(
                                (e) => print(e));
                      }
                    }

                    return Column(children: [
                      ListTile(
                        leading: CircleAvatar(
                            child: image != null
                                ? Image.network(image,
                                    errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) =>
                                        const Icon(Icons.error))
                                : const Icon(Icons.image)),
                        title: Text(name!,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(category!,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text("Rs $price",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        onTap: saveToCart,
                      ),
                      const Divider(height: 0, color: Colors.black),
                    ]);
                  },
                )
              : const Center(child: Text("No data found")),
        ),
      );
}
