import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'categories/categories.dart';
import 'menu.dart';

class Menus extends StatelessWidget {
  const Menus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => MenuList());
              },
              child: ListTile(
                title: Text('Menu'),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => Categories());
              },
              child: ListTile(
                title: Text('Categories'),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text('Ready order descriptions'),
            ),
          ],
        ),
      ),
    );
  }
}
