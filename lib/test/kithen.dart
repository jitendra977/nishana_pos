import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KitchenOrderPage extends StatefulWidget {
  final String orderNumber;
  final String tableNumber;

  KitchenOrderPage({
    required this.orderNumber,
    required this.tableNumber,
    required List<Map<String, Object>> items,
  });

  @override
  _KitchenOrderPageState createState() => _KitchenOrderPageState();
}

class _KitchenOrderPageState extends State<KitchenOrderPage> {
  final cookingColor = Colors.orangeAccent;
  final readyColor = Colors.greenAccent;
  late List<DataRow> dataRows;
  int? selectedTable;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final data = await FirebaseFirestore.instance
        .collection("kitchen_order")
        .where('table_number', isEqualTo: widget.tableNumber)
        .get();

    dataRows = data.docs.map((doc) {
      final item = doc.data();
      return DataRow(
        cells: [
          DataCell(
            Text('- ${item['name']}', style: TextStyle(fontSize: 16.0)),
          ),
          DataCell(
            Text('x${item['quantity']}', style: TextStyle(fontSize: 16.0)),
          ),
          DataCell(
            Icon(
              item['isCooking'] ?? true
                  ? Icons.fireplace_rounded
                  : Icons.check_circle_rounded,
              color: item['isCooking'] ?? true ? cookingColor : readyColor,
            ),
          ),
        ],
      );
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            final tableNumber = index + 1;
            final isTableOpen = selectedTable == tableNumber;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedTable = isTableOpen ? null : tableNumber;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    color: isTableOpen
                        ? Colors.green.shade800
                        : Colors.blue.shade500,
                    child: Row(
                      children: [
                        const SizedBox(width: 16.0),
                        Text(
                          'Table #$tableNumber',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isTableOpen)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    color: Colors.lightBlue.shade50,
                    constraints: BoxConstraints(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text('Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Quantity',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Status',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: dataRows,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
