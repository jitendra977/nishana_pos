import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TablePopup extends StatelessWidget {
  final Query<Map<String, dynamic>> restaurantTableCollection =
      FirebaseFirestore.instance
          .collection('restaurant_table')
          .where('status', isEqualTo: 'Available');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a table'),
      content: SizedBox(
        width: double.maxFinite,
        child: StreamBuilder<QuerySnapshot>(
          stream: restaurantTableCollection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                String table = documents[index]['table_name'] as String;

                return buildOptionTile(table, Icons.table_bar, onTap: () {
                  // Handle the selected table
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildOptionTile(String title, IconData icon, {VoidCallback? onTap}) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
      ),
    );
  }
}
