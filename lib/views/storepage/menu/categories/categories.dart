import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_categories.dart';

class Categories extends StatefulWidget {
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  TextEditingController _editingController = TextEditingController();
  bool _isEditing = false;
  late String _editedCategoryName;

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _startEditing(String categoryName) {
    setState(() {
      _editedCategoryName = categoryName;
      _editingController.text = categoryName;
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _saveChanges(String categoryName, String docId) {
    FirebaseFirestore.instance
        .collection("categories")
        .doc(docId)
        .update({"category_name": _editingController.text}).then((_) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category name updated')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update category name')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddCategories());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Categories'),
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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("categories").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No data found"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var name = doc['category_name'];
              var priority = doc['priority'];

              return ListTile(
                title: _isEditing && _editedCategoryName == name
                    ? TextFormField(
                        controller: _editingController,
                        decoration: InputDecoration(
                          labelText: 'Category Name',
                        ),
                      )
                    : Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                trailing: _isEditing && _editedCategoryName == name
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
                subtitle: Text("Priority: $priority"),
              );
            },
          );
        },
      ),
    );
  }
}
