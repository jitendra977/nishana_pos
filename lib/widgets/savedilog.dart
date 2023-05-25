import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SaveToKitchen extends StatelessWidget {
  final String tableNumber;

  const SaveToKitchen({required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save To Kitchen'),
      content: SizedBox(
        width: double.maxFinite,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("cart_items")
              .where('table_number', isEqualTo: tableNumber)
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
              return const Center(child: Text("No data available"));
            }

            final itemTiles = data.docs
                .map((item) => ListTile(
                      title: Text(item['itemName']),
                      trailing: Text(item['qty'].toString()),
                    ))
                .toList();

            return ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    itemTiles[index],
                  ],
                );
              },
              itemCount: itemTiles.length,
            );
          },
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: Text("Back")),
        ElevatedButton(
          onPressed: () async {
            final User? userId = FirebaseAuth.instance.currentUser;
            final cartitemRef =
                FirebaseFirestore.instance.collection('cart_items');

            final snapshot = await cartitemRef
                .where('table_number', isEqualTo: tableNumber)
                .get();

            if (snapshot.docs.isEmpty) {
              return;
            }

            // Update each document in the snapshot
            for (final doc in snapshot.docs) {
              await cartitemRef.doc(doc.id).update({
                'status': 'saved',
                'date': DateTime.now(),
                'userId': userId?.uid
              });
            }

            // update restaurant table

            Navigator.pop(context);
          },
          child: const Text('Save to Kitchen'),
        ),
      ],
    );
  }
}
