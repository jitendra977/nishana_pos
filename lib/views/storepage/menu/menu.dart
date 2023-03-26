// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/views/storepage/menu/add_menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          stream:
              FirebaseFirestore.instance.collection("menu_items").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("something error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No data Found"),
              );
            }
            if (snapshot != null && snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var name = snapshot.data?.docs[index]['item_name'];
                  var category = snapshot.data?.docs[index]['category'];
                  var image = snapshot.data?.docs[index]['img_url'];
                  var price = snapshot.data?.docs[index]['price'];

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
                            trailing: Text("Rs ${price}",
                                style: TextStyle(fontWeight: FontWeight.bold))),
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
        ));
  }
}
