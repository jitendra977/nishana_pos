import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../models/restaurant_table.dart';

class AddTables extends StatefulWidget {
  @override
  _AddTablesState createState() => _AddTablesState();
}

class _AddTablesState extends State<AddTables> {
  final _formKey = GlobalKey<FormState>();
  RestaurantTable _restaurantTable = RestaurantTable();
  TextEditingController _tableNameController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Table'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _tableNameController,
                  decoration: InputDecoration(
                      hintText: 'Table Name', border: OutlineInputBorder()),
                  onChanged: (value) => _restaurantTable.tableName = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _priorityController,
                  decoration: InputDecoration(
                      hintText: 'Priority', border: OutlineInputBorder()),
                  onChanged: (value) => _restaurantTable.priority = value,
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  value: _restaurantTable.floor,
                  hint: Text('Select Floor'),
                  items: ['Floor 1', 'Floor 2', 'Floor 3']
                      .map(
                        (floor) => DropdownMenuItem(
                          value: floor,
                          child: Text(floor),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(
                    () => _restaurantTable.floor = value!,
                  ),
                ),
                ElevatedButton(
                  onPressed: _onSaveButtonPressed,
                  child: Text('Add Table'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSaveButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      final table = RestaurantTable(
          tableName: _tableNameController.text,
          priority: _priorityController.text,
          floor: _restaurantTable.floor,
          status: "Avialable"
          // Use the value from _restaurantTable
          );

      try {
        await FirebaseFirestore.instance
            .collection("restaurant_table")
            .doc()
            .set(table.toJson());
        Navigator.pop(context);
      } catch (e) {
        print('Error adding table: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding table'),
          ),
        );
      }
    }
  }
}
