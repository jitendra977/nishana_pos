// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/views/storepage/other_page/tables/tables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OthersPages extends StatefulWidget {
  @override
  State<OthersPages> createState() => _OthersPagesState();
}

class _OthersPagesState extends State<OthersPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('OthersPages'),
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
      body: Column(
        children: [
          ListTile(
            leading: Icon(CupertinoIcons.doc_text),
            title: Text("Delivery Person"),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.doc_text),
            title: Text("Payment Type"),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => Tables());
            },
            child: ListTile(
              leading: Icon(CupertinoIcons.bed_double),
              title: Text("Tables"),
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.doc_text),
            title: Text("Floors"),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.music_note_2),
            title: Text("Web Application"),
          ),
        ],
      ),
    );
  }
}
