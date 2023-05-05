// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishanapos/models/add_to_cart.dart';
import 'package:provider/provider.dart';
import '../../Services/Providers/CartProviders/GrandTotalProvider.dart';
import 'menu/add_menu_item.dart';

final _formKey = GlobalKey<FormState>();
var totalPrice = 0;

class CartPage extends StatefulWidget {
  final String restaurantTable;

  const CartPage({super.key, required, required this.restaurantTable});

  @override
  State<CartPage> createState() => _CartPageState();
}

String _SelectedCategoryName = 'Tea';
User? userId = FirebaseAuth.instance.currentUser;

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cart Page'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.credit_card),
          ),
          IconButton(
            onPressed: () async {
              // await FirebaseFirestore.instance.doc().delete();
            },
            icon: Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.print),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
                color: Color.fromARGB(255, 85, 66, 4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.restaurantTable,
                        style: TextStyle(
                            color: Color.fromARGB(255, 253, 250, 250),
                            fontSize: 20),
                      ),
                      Text(
                        "Bill No: A5422",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20),
                      ),
                      Text(
                        totalPrice.toString(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20),
                      ),
                    ],
                  ),
                )),
            Container(
              color: Color.fromARGB(255, 255, 255, 255),
              height: MediaQuery.of(context).size.height / 2.5,
              child: CartTable(),
            ),
            Container(
                color: Color.fromRGBO(128, 12, 12, 1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menu",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      MenuIconR(),
                    ],
                  ),
                )),
            Expanded(
              child: Container(
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Row(
                    children: [
                      Container(
                          color: Colors.red,
                          width: 130,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("categories")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("something error");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text("No data Found"),
                                );
                              }
                              if (snapshot != null && snapshot.data != null) {
                                return ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    var name = snapshot.data?.docs[index]
                                        ['category_name'];

                                    return Container(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _SelectedCategoryName = name;
                                              });
                                              print(name);
                                            },
                                            child: Card(
                                              child: ListTile(
                                                title: Text(
                                                  name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 0,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container();
                            },
                          )),
                      ShowItems(),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowItems extends StatefulWidget {
  const ShowItems({
    super.key,
  });

  @override
  State<ShowItems> createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("menu_items")
          .where("category", isEqualTo: _SelectedCategoryName)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("something error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No data Found"),
          );
        }
        if (snapshot != null && snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var name = snapshot.data?.docs[index]['item_name'];
              var category = snapshot.data?.docs[index]['category'];
              var image = snapshot.data?.docs[index]['img_url'];
              var price = snapshot.data?.docs[index]['price'];

              void SaveToCart() {
                totalPrice += int.parse(price);
                if (_formKey.currentState!.validate()) {
                  final _addtocart = AddToCart(
                    itemName: name,
                    date: DateTime.now().toString(),
                    price: int.tryParse(price),
                    qty: 1,
                    userId: userId?.uid,
                    tableNumber: "Table1",
                  );
                  try {
                    FirebaseFirestore.instance
                        .collection("cart_items")
                        .doc()
                        .set(_addtocart.toJson());
                  } catch (e) {
                    print(e);
                  }
                }
              }

              if (image == null || image.isEmpty) {
                return Center(child: CupertinoActivityIndicator());
              }
              return Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          SaveToCart();
                        });
                      },
                      child: ListTile(
                          leading: CircleAvatar(
                            child: image != null
                                ? Image.network(
                                    image,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  )
                                : const Icon(Icons.image),
                          ),
                          title: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            category,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text("Rs ${price}",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                    Divider(
                      height: 0,
                      color: Colors.black,
                    )
                  ],
                ),
              );
            },
          );
        }
        return Container();
      },
    ));
  }
}

class CartTable extends StatelessWidget {
  const CartTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("cart_items").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          double grandTotal = 0;

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("no data available"));
          }
          if (snapshot != null && snapshot.data != null) {
            for (var item in snapshot.data!.docs) {
              grandTotal += item['qty'] * item['price'];
            }
            GrandTotalProvider grandTotalProvider =
                Provider.of<GrandTotalProvider>(context, listen: false);

            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Table(
                border: TableBorder.lerp(
                  TableBorder.all(width: 1.0, color: Colors.red),
                  TableBorder.all(width: 2.0, color: Colors.blue),
                  0.5,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(boxShadow: List.empty()),
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
                      TableCell(
                        child: SizedBox(), // empty cell for spacing
                      ),
                    ],
                  ),
                  for (var item in snapshot.data!.docs)
                    TableRow(
                      children: [
                        TableCell(
                          child: IntrinsicWidth(child: Text(item['itemName'])),
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
                                  (item['qty'] * item['price']).toString())),
                        ),
                        TableCell(
                          child: GestureDetector(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('cart_items')
                                    .doc(item.id)
                                    .delete();
                              },
                              child:
                                  Icon(Icons.delete)), // empty cell for spacing
                        ),
                      ],
                    ),
                ],
              ),
            ));
            grandTotalProvider.updateGrandTotal(grandTotal);
          }

          return Container();
        },
      ),
    );
  }

  static TableRow _buildTableRow(List<dynamic> data) {
    return TableRow(
      children: data
          .map((cellData) => TableCell(
                child: cellData is Icon
                    ? IconButton(icon: cellData, onPressed: () {})
                    : Text('$cellData'),
              ))
          .toList(),
    );
  }
}

class MenuIconR extends StatelessWidget {
  const MenuIconR({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(spacing: 15, children: <Widget>[
        Icon(
          Icons.camera_enhance,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          color: Colors.white,
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => AddMenuItem());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        Icon(
          Icons.info_outline,
          color: Colors.white,
        ),
        Icon(
          Icons.menu,
          color: Colors.white,
        ),
        Icon(
          Icons.close,
          color: Colors.white,
        ),
      ]),
    );
  }
}
