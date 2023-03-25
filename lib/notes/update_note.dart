// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notes.dart';

class UpdateNote extends StatelessWidget {
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Notes"),
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
                  controller: titleController
                    ..text = "${Get.arguments['title'].toString()}",
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: noteController
                    ..text = "${Get.arguments['note'].toString()}",
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('notes')
                        .doc(Get.arguments['docId'].toString())
                        .update({
                      'title': titleController.text.trim(),
                      'note': noteController.text.trim()
                    }).then((value) =>
                            {Get.to(() => MyNotes()), print("note Updated")});
                  },
                  child: Text("Update")),
            ],
          ),
        ),
      ),
    );
  }
}
