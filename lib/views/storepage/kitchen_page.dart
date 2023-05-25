import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class KitchenOrderPage extends StatefulWidget {
  @override
  State<KitchenOrderPage> createState() => _KitchenOrderPageState();
}

class _KitchenOrderPageState extends State<KitchenOrderPage> {
  final cookingColor = Colors.orangeAccent;

  final readyColor = Colors.greenAccent;
  Map<String, bool> tableVisibilityMap = {};

  void toggleTableVisibility(String tableNumber) {
    setState(() {
      if (tableVisibilityMap.containsKey(tableNumber)) {
        tableVisibilityMap[tableNumber] = !tableVisibilityMap[tableNumber]!;
      } else {
        tableVisibilityMap[tableNumber] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen Order')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("cart_items")
            .where('status', isNotEqualTo: 'complete')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No order haven't"),
            );
          }

          final querySnapshot = snapshot.data!;
          final tables = querySnapshot.docs
              .groupBy((doc) => doc['table_number'])
              .entries
              .map((entry) {
            final tableNumber = entry.key;
            final rows = entry.value.map((doc) {
              IconData icon;
              Color color;
              final status = doc['status'];
              switch (status) {
                case 'saved':
                  icon = Icons.fireplace_rounded;
                  color = Color.fromARGB(255, 111, 0, 255);
                  break;
                case 'cooking':
                  icon = Icons.restaurant_menu;
                  color = cookingColor;
                  break;
                case 'ready':
                  icon = Icons.check_circle;
                  color = readyColor;
                  break;
                default:
                  icon = Icons.done_all;
                  color = Colors.grey;
                  break;
              }

              final Timestamp timestamp = doc['date'];
              final dateFormatter = DateFormat('HH:mm');
              final date = timestamp.toDate();
              final timeString = dateFormatter.format(date);

              return DataRow(
                cells: [
                  DataCell(Text(doc['itemName'],
                      style: const TextStyle(fontSize: 16.0))),
                  DataCell(Text('x${doc['qty']}',
                      style: const TextStyle(fontSize: 16.0))),
                  DataCell(Text(timeString.toString(),
                      style: const TextStyle(fontSize: 16.0))),
                  DataCell(InkWell(
                    child: Icon(icon, color: color),
                    onTap: () async {
                      final newStatus = (status == 'saved')
                          ? 'cooking'
                          : (status == 'cooking')
                              ? 'ready'
                              : (status == 'ready')
                                  ? 'delivered'
                                  : status;
                      // Update cart_items collection
                      await FirebaseFirestore.instance
                          .collection('cart_items')
                          .doc(doc.id)
                          .update({'status': newStatus});

                      // Update restaurant_table collection
                      final tableNumber = doc['table_number'];
                      final tableSnapshot = await FirebaseFirestore.instance
                          .collection('restaurant_table')
                          .where('table_name', isEqualTo: tableNumber)
                          .get();
                      final tableDoc = tableSnapshot.docs.first;
                      final currentStatus = tableDoc['status'];
                      if (currentStatus != 'complete') {
                        await tableDoc.reference.update({'status': newStatus});
                      }
                    },
                  )),
                ],
              );
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    toggleTableVisibility(tableNumber);
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.green.shade800,
                      child: Row(
                        children: [
                          const SizedBox(width: 16.0),
                          Text('$tableNumber',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              )),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('cart_items')
                                      .where('table_number',
                                          isEqualTo: tableNumber)
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference
                                          .update({'status': 'complete'});
                                    });
                                  });
                                },
                                child: Icon(
                                    CupertinoIcons.check_mark_circled_solid,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Visibility(
                  visible: tableVisibilityMap[tableNumber] ?? false,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                          label: Text('Name',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Quantity',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('time',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Status',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: rows,
                    dataRowHeight: 50,
                    columnSpacing: 25,
                  ),
                ),
              ],
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              shrinkWrap: true,
              children: tables,
            ),
          );
        },
      ),
    );
  }
}
