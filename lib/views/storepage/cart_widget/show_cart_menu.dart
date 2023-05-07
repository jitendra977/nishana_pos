import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/add_to_cart.dart';

class ShowItems extends StatelessWidget {
  
  final User? userId = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) => Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("menu_items")
              .where("category")
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

class ShowCategories extends StatefulWidget {
  const ShowCategories({Key? key}) : super(key: key);

  @override
  State<ShowCategories> createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories> {
  var _selectedCategoryName = 'Soft Drinks';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("categories").snapshots(),
      builder: (context, snapshot) => snapshot.hasData
          ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryName =
                            snapshot.data?.docs[index]['category_name'];
                        print(_selectedCategoryName);
                      });
                    },
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                         snapshot.data?.docs[index]["category_name"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 0, color: Colors.black),
                ],
              ),
            )
          : snapshot.hasError
              ? const Text("Something went wrong")
              : const Center(child: CupertinoActivityIndicator()),
    );
  }
}
