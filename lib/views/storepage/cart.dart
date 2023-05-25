// ignore_for_file: unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishanapos/widgets/savedilog.dart';
import 'package:provider/provider.dart';
import '../../Services/Providers/CartProviders/grandTotalProvider.dart';
import '../../Services/Providers/Category_selector.dart';
import '../../models/add_to_cart.dart';
import 'Payment/payment_page.dart';
import 'cart_widget/cart_table.dart';
import 'menu/add_menu_item.dart';

class CartPage extends StatefulWidget {
  final String restaurantTable;
  const CartPage({super.key, required, required this.restaurantTable});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final User? userId = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cart Page'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PaymentOptionsPopup(
                    restaurantTable: widget.restaurantTable),
              );
              Provider.of<GrandTotalProvider>(context, listen: false)
                  .updateGrandTotal(widget.restaurantTable);
            },
            icon: Icon(Icons.credit_card),
          ),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) =>
                  SaveToKitchen(tableNumber: widget.restaurantTable),
            ),
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
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 2.5,
            child: CartTable(restaurantTable: widget.restaurantTable),
          ),
          Container(
            color: Color.fromRGBO(128, 12, 12, 1),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MenuHeader(),
              ],
            ),
          ),
          Expanded(
            child: ItemsListGet(),
          ),
        ],
      ),
    );
  }

  Container ItemsListGet() {
    return Container(
      color: Color.fromARGB(255, 238, 240, 242),
      child: Expanded(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: CategoryGet(),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Consumer<CategoryProvider>(
                      builder: (BuildContext context, value, Widget? child) {
                        Stream<QuerySnapshot> getMenuItemsStream(
                            String selectedCategoryName) {
                          CollectionReference menuItemsRef = FirebaseFirestore
                              .instance
                              .collection('menu_items');

                          return selectedCategoryName == "All"
                              ? menuItemsRef.snapshots()
                              : menuItemsRef
                                  .where("category",
                                      isEqualTo: selectedCategoryName)
                                  .snapshots();
                        }

                        return StreamBuilder<QuerySnapshot>(
                          stream:
                              getMenuItemsStream(value.selectedCategoryName),
                          builder: (context, snapshot) {
                            if (snapshot.hasError)
                              return Text('Something went wrong');
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return Text('Loading...');

                            List<Map<String, dynamic>> items =
                                snapshot.data!.docs
                                    .map((doc) => {
                                          'item_name': doc.get('item_name'),
                                          'img_url': doc.get('img_url'),
                                          'price': doc.get('price'),
                                        })
                                    .toList();

                            return Expanded(
                              child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  void saveToCart() async {
                                    final cartItems = await FirebaseFirestore
                                        .instance
                                        .collection("cart_items")
                                        .where("itemName",
                                            isEqualTo: items[index]
                                                ['item_name'])
                                        .where("userId", isEqualTo: userId?.uid)
                                        .where('table_number',
                                            isEqualTo: widget.restaurantTable)
                                        .get();

                                    if (cartItems.docs.isEmpty) {
                                      FirebaseFirestore.instance
                                          .collection("cart_items")
                                          .doc()
                                          .set(
                                            AddToCart(
                                              itemName: items[index]
                                                  ['item_name'],
                                              date: DateTime.now().toString(),
                                              price: items[index]['price'],
                                              qty: 1,
                                              status: 'none',
                                              userId: userId?.uid,
                                              tableNumber:
                                                  widget.restaurantTable,
                                            ).toJson(),
                                          )
                                          .catchError((e) => print(e));
                                    } else {
                                      final cartItem = cartItems.docs.first;
                                      final currentQty = cartItem['qty'];
                                      FirebaseFirestore.instance
                                          .collection("cart_items")
                                          .doc(cartItem.id)
                                          .update({
                                        "qty": currentQty + 1
                                      }).catchError((e) => print(e));
                                    }
                                  }

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 6.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        saveToCart();
                                        Provider.of<GrandTotalProvider>(context,
                                                listen: false)
                                            .updateGrandTotal(
                                                widget.restaurantTable);
                                      },
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
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 10.0),
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: FadeInImage(
                                              placeholder: AssetImage(
                                                  'assets/logo/logo.png'),
                                              image: NetworkImage(
                                                  items[index]['img_url']),
                                              fit: BoxFit.cover,
                                              imageErrorBuilder: (_, __, ___) =>
                                                  Icon(Icons.error),
                                            ),
                                          ),
                                          title: Flexible(
                                            child: Text(
                                              items[index]['item_name']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Rs.${items[index]['price']}',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryGet extends StatelessWidget {
  const CategoryGet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something went wrong');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Text('Loading...');

          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          final List categoryNames = documents
              .map((doc) => doc.get('category_name'))
              .toList()
            ..insert(0, "All");

          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: categoryNames.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
                child: Consumer<CategoryProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    return ElevatedButton(
                      onPressed: () {
                        value.setSelectedCategoryName(categoryNames[index]);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: Text(
                        categoryNames[index],
                        style: const TextStyle(
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
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  final List<dynamic> iconData = [
    Icons.camera_enhance,
    Icons.search,
    {
      'icon': Icons.add,
      'onTap': () => Get.to(() => AddMenuItem()),
    },
    Icons.info_outline,
    Icons.menu,
    Icons.close,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 65),
            child: Text(
              "Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                for (var item in iconData)
                  GestureDetector(
                    onTap: item is Map
                        ? (item)['onTap'] as void Function()?
                        : null,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: item == iconData.first ? 0 : 12),
                      child: Icon(
                        item is IconData
                            ? item
                            : (item as Map)['icon'] as IconData,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
