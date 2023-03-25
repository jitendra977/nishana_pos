import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/views/storepage/menu/categories/categories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCategories extends StatefulWidget {
  @override
  _AddCategoriesState createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  User? UserId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Categories'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var name = _nameController.text.trim();
              var priority = _priorityController.text.trim();

              if (name != "" && priority != "") {
                try {
                  await FirebaseFirestore.instance
                      .collection("categories")
                      .doc()
                      .set({
                    'createdAt': DateTime.now(),
                    'category_name': name,
                    'userId': UserId?.uid,
                    'priority': priority,
                  }).then((value) => {Get.offAll(() => Categories())});
                } catch (e) {
                  print("error: " + e.toString());
                }
              }
              print("Error Enter all field");
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category Name',
                ),
                maxLines: null,
              ),
              TextField(
                controller: _priorityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Priority',
                ),
              ),
            ].insertBetweenAll(SizedBox(height: 10)),
          ),
        ),
      ),
    );
  }
}

// spacing between columns ========================
extension on List<Widget> {
  List<Widget> insertBetweenAll(Widget widget) {
    var result = List<Widget>.empty(growable: true);
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) {
        result.add(widget);
      }
    }
    return result;
  }
}
