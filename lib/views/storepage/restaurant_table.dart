import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishanapos/views/storepage/cart.dart';
import 'package:provider/provider.dart';

import '../../Services/Providers/CartProviders/grandTotalProvider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<void> updateRestaurantTable(String tableNumber) async {
    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('cart_items')
        .where('table_number', isEqualTo: tableNumber)
        .where('status', isEqualTo: 'ready')
        .limit(1)
        .get();

    final restaurantTableRef =
        FirebaseFirestore.instance.collection('restaurant_table');

    if (cartItemsSnapshot.size == 0) {
      await restaurantTableRef
          .where('table_name', isEqualTo: tableNumber)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final restaurantTableDoc = snapshot.docs.first;
          restaurantTableRef
              .doc(restaurantTableDoc.id)
              .update({'status': 'Avialable'});
        }
      });
    }

    setState(() {}); // Trigger a rebuild of the widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Order'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurant_table')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data found"));
          }
          final tables = snapshot.data!.docs;
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];
              final status = table['status'];
              final tableName = table['table_name'];

              Color containerColor;
              if (status == 'cooking') {
                containerColor = Colors.amber[200]!;
              } else if (status == 'ready') {
                containerColor = Colors.red; // Set your desired color
              } else if (status == 'Avialable') {
                containerColor = Colors.blue; // Set your desired color
              } else {
                containerColor = Colors.grey[200]!;
              }

              return GestureDetector(
                onTap: () async {
                  await updateRestaurantTable(tableName);
                  Get.to(() => CartPage(restaurantTable: tableName));
                  Provider.of<GrandTotalProvider>(context, listen: false)
                      .updateGrandTotal(tableName);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.amber),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: containerColor,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          tableName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          status,
                          style: TextStyle(fontSize: 12),
                        ), // Display the status
                        Icon(Icons.local_restaurant),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
