// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notes.dart';

class AddNote extends StatelessWidget {
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  User? UserId = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: titleController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Title",
                    enabledBorder: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: noteController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "type note here",
                    enabledBorder: OutlineInputBorder(),
                  )),
              ElevatedButton(
                  onPressed: () {
                    var title = titleController.text.trim();
                    var note = noteController.text.trim();

                    if (title != "" && note != "") {
                      try {
                        FirebaseFirestore.instance
                            .collection("notes")
                            .doc()
                            .set({
                          'createdAt': DateTime.now(),
                          'userId': UserId?.uid,
                          'title': title,
                          'note': note
                        }).then((value) => {Get.offAll(() => MyNotes())});
                      } catch (e) {
                        print("error: " + e.toString());
                      }
                    }
                    print("type note and title");
                  },
                  child: Text("Add")),
            ],
          ),
        ),
      ),
    );
  }
}
