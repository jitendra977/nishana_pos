// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_table.dart';

class Tables extends StatefulWidget {
  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
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
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("categories").snapshots(),
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
                  var name = snapshot.data?.docs[index]['category_name'];

                  return Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
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
