// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tables/tables.dart';

class OthersPages extends StatefulWidget {
  @override
  State<OthersPages> createState() => _OthersPagesState();
}

class _OthersPagesState extends State<OthersPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
