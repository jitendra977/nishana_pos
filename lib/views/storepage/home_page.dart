import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishanapos/views/storepage/kitchen_page.dart';
import 'package:nishanapos/views/storepage/restaurant_account.dart';
import 'package:nishanapos/views/storepage/takeaway.dart';
import '../../notes/notes.dart';
import '../loginScreen.dart';
import '../user_management.dart';
import 'menu/menus.dart';
import 'restaurant_table.dart';
import 'other_page/others_page.dart';

late DocumentReference userDocRef;

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Nishana'),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.home),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.off(() => LoginScreen());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ListTileTheme(
            dense: true,
            textColor: Colors.grey[800],
            selectedColor: Colors.blue,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              leading: Icon(icon, size: 24),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          _buildListTile(
              'Order', Icons.restaurant, () => Get.to(() => OrderPage())),
          _buildListTile('Notes', Icons.note, () => Get.to(() => MyNotes())),
          _buildListTile('Customer Order Take away', Icons.pedal_bike,
              () => Get.to(() => TakeAwayOrderPage())),
          _buildListTile('Kitchen 1', Icons.cookie_outlined,
              () => Get.to(() => KitchenOrderPage())),
          _buildListTile('Bar', Icons.food_bank, () {}),
          _buildListTile('Menu', Icons.apps, () => Get.to(() => Menus())),
          _buildListTile('Order Setting', Icons.settings, () {}),
          _buildListTile('Print Settings', Icons.print_rounded, () {}),
          _buildListTile('Restaurant Account', Icons.person_add,
              () => Get.to(() => RestaurantAccountPage())),
          _buildListTile('Help Center', Icons.help_center, () {}),
          _buildListTile('Day-End Report', Icons.list_alt, () {}),
          _buildListTile('Summary Of the Day', Icons.list_sharp, () {}),
          _buildListTile('Order List', Icons.list_alt_sharp, () {}),
          _buildListTile('Cancelled Order', Icons.cancel, () {}),
          _buildListTile('Invoice List', Icons.apps, () {}),
          _buildListTile('Order to be delivered', Icons.apps, () {}),
          _buildListTile('Inventory', Icons.bar_chart, () {}),
          _buildListTile('Expense', Icons.apps, () {}),
          _buildListTile('Report', Icons.apps, () {}),
          GestureDetector(
            onTap: () => Get.to(() => OthersPages()),
            child: _buildListTile(
                'Other', Icons.apps, () => Get.to(() => OthersPages())),
          ),
          _buildListTile('User Management', Icons.manage_accounts,
              () => Get.to(() => UserDetailPage())),
        ],
      ),
    );
  }
}
