// ignore_for_file: unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishanapos/Services/Providers/CartProviders/GrandTotalProvider.dart';
import 'package:provider/provider.dart';

import '../../Services/Providers/Category_selector.dart';
import 'cart_widget/cart_table.dart';
import 'menu/add_menu_item.dart';

class CartPage extends StatefulWidget {
  final String restaurantTable;
  const CartPage({super.key, required, required this.restaurantTable});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
      body: Column(
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
                    Consumer<GrandTotalProvider>(
                      builder: (BuildContext context, value, Widget? child) {
                        return Text(
                          value.grandTotal.toString(),
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20),
                        );
                      },
                    ),
                  ],
                ),
              )),
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            height: MediaQuery.of(context).size.height / 2.5,
            child: CartTable(restaurantTable: widget.restaurantTable),
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
              color: Color.fromARGB(255, 238, 240, 242),
              child: Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('categories')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading...');
                          }
                          final List<DocumentSnapshot> documents =
                              snapshot.data!.docs;

                          // Extract category names from the documents
                          final List categoryNames = documents
                              .map((doc) => doc.get('category_name'))
                              .toList();

                          return ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: categoryNames.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.0, horizontal: 6.0),
                                child: Consumer<CategoryProvider>(
                                  builder: (BuildContext context, value,
                                      Widget? child) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        value.setSelectedCategoryName(
                                            categoryNames[index]);
                                        print(value.selectedCategoryName);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0),
                                      ),
                                      child: Text(
                                        categoryNames[index],
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      )),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            // Add your item details here
                            Consumer<CategoryProvider>(
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('menu_items')
                                      .where("category",
                                          isEqualTo: value.selectedCategoryName)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      return Text('Something went wrong');
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting)
                                      return Text('Loading...');

                                    List<Map<String, dynamic>> items =
                                        snapshot.data!.docs
                                            .map((doc) => {
                                                  'item_name':
                                                      doc.get('item_name'),
                                                  'img_url': doc.get('img_url'),
                                                  'price': doc.get('price'),
                                                })
                                            .toList();
                                    return Expanded(
                                      child: ListView.builder(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemCount: items.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.0, horizontal: 6.0),
                                            child: Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                  color: Colors.grey.shade300,
                                                  width: 1,
                                                ),
                                              ),
                                              child: ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 10.0,
                                                ),
                                                leading: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: FadeInImage(
                                                    placeholder: AssetImage(
                                                        'assets/logo/logo.png'),
                                                    image: NetworkImage(
                                                        items[index]
                                                            ['img_url']),
                                                    fit: BoxFit.cover,
                                                    imageErrorBuilder:
                                                        (_, __, ___) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                                title: Flexible(
                                                  child: Text(
                                                    items[index]['item_name']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                subtitle: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    'Rs.${items[index]['price']}',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
