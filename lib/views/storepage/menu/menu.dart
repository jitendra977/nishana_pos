import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_menu_item.dart';

class MenuList extends StatefulWidget {
  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddMenuItem());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('MenuList'),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("menu_items").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var name = doc['item_name'];
                var category = doc['category'];
                var image = doc['img_url'];
                var price = doc['price'];

                if (image == null || image.isEmpty) {
                  return Center(child: CupertinoActivityIndicator());
                }
                return Container(
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: image != null
                              ? Image.network(
                                  image,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    // Return an ErrorWidget when the image fails to load
                                    return const Icon(Icons.error);
                                  },
                                )
                              : const Icon(Icons.image),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          category,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          "Rs $price",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Get.to(() => EditMenuItem(docId: doc.id));
                        },
                      ),
                      Divider(
                        height: 0,
                        color: Colors.black,
                      )
                    ],
                  ),
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

class EditMenuItem extends StatefulWidget {
  final String docId;

  const EditMenuItem({required this.docId});

  @override
  _EditMenuItemState createState() => _EditMenuItemState();
}

class _EditMenuItemState extends State<EditMenuItem> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _categoryController = TextEditingController();
    _priceController = TextEditingController();
    fetchMenuItemDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void fetchMenuItemDetails() {
    FirebaseFirestore.instance
        .collection("menu_items")
        .doc(widget.docId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        _nameController.text = data['item_name'];
        _categoryController.text = data['category'];
        _priceController.text = data['price'].toString();
      }
    }).catchError((error) {
      // Handle error
    });
  }

  void updateMenuItem() {
    String name = _nameController.text;
    String category = _categoryController.text;
    double price = double.parse(_priceController.text);

    FirebaseFirestore.instance
        .collection("menu_items")
        .doc(widget.docId)
        .update({
      'item_name': name,
      'category': category,
      'price': price,
    }).then((_) {
      // Successfully updated
      Get.back();
    }).catchError((error) {
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Menu Item'),
        actions: [
          IconButton(
            onPressed: updateMenuItem,
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
              ),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
              ),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
