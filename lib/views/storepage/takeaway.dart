// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class TakeAwayOrderPage extends StatefulWidget {
  @override
  _TakeAwayOrderPageState createState() => _TakeAwayOrderPageState();
}

class _TakeAwayOrderPageState extends State<TakeAwayOrderPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  void submitOrder() {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;

    // Perform order submission logic here
    // You can send the order details to your backend or perform any desired actions

    // Clear the text fields
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();

    // Show a confirmation dialog or navigate to a success page
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Submitted'),
        content: Text('Your order has been submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take-Away Order'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitOrder,
              child: Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}
