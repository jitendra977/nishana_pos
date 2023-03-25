// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_notes.dart';
import 'update_note.dart';

class MyNotes extends StatelessWidget {
  User? UserId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
      ),
      body: Container(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("notes")
            .where("userId", isEqualTo: UserId?.uid)
            .snapshots(),
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
                var title = snapshot.data?.docs[index]['title'];
                var note = snapshot.data?.docs[index]['note'];
                var docId = snapshot.data?.docs[index].id;

                return Card(
                  child: ListTile(
                    title: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(note),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: Icon(Icons.edit),
                          onTap: () {
                            Get.to(() => UpdateNote(), arguments: {
                              'note': note,
                              'title': title,
                              'docId': docId,
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('notes')
                                  .doc(docId)
                                  .delete();
                            },
                            child: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddNote());
        },
        child: Text("+"),
      ),
    );
  }
}
