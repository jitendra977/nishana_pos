// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_table.dart';

class Tables extends StatefulWidget {
  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  TextEditingController _editingController = TextEditingController();
  bool _isEditing = false;
  late String _editedTableName;

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _startEditing(String tableName) {
    setState(() {
      _editedTableName = tableName;
      _editingController.text = tableName;
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _saveChanges(String tableName, String docId) {
    FirebaseFirestore.instance
        .collection("restaurant_table")
        .doc(docId)
        .update({"table_name": _editingController.text}).then((_) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table name updated')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update table name')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddTables());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tables'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Option 1'),
                ),
                PopupMenuItem(
                  child: Text('Option 2'),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("restaurant_table")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No data found"),
            );
          }
          if (snapshot != null && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var name = doc['table_name'];
                var floor = doc['status'];

                return ListTile(
                  title: _isEditing && _editedTableName == name
                      ? TextFormField(
                          controller: _editingController,
                          decoration: InputDecoration(
                            labelText: 'Table Name',
                          ),
                        )
                      : Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                  trailing: _isEditing && _editedTableName == name
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _saveChanges(name, doc.id),
                              icon: Icon(Icons.check),
                            ),
                            IconButton(
                              onPressed: _cancelEditing,
                              icon: Icon(Icons.close),
                            ),
                          ],
                        )
                      : IconButton(
                          onPressed: () => _startEditing(name),
                          icon: Icon(Icons.edit),
                        ),
                  subtitle: Text(floor),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
