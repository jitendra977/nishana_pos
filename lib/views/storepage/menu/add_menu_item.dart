import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'menu.dart';

String _selectedCategory = list.first;

const List<String> list = <String>[
  'Select Category',
  'Drinks',
  'Choumin',
  'Diner',
  'Salad'
];

class AddMenuItem extends StatefulWidget {
  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<void> _getCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    final categories = snapshot.docs
        .map((doc) => doc.data()['category_name'] as String)
        .toList();
    setState(() {
      _categories = categories;
      print(_categories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Menu'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var name = _nameController.text.trim();
              var price = _priceController.text.trim();
              var qty = _qtyController.text.trim();
              var img_url = _imageController.text.trim();
              var description = _descController.text.trim();
              var barcode = _barcodeController.text.trim();

              if (name != "" &&
                  price != "" &&
                  _selectedCategory != "Select Category" &&
                  qty != "" &&
                  description != "" &&
                  barcode != "") {
                try {
                  await FirebaseFirestore.instance
                      .collection("menu_items")
                      .doc()
                      .set({
                    'createdAt': DateTime.now(),
                    'item_name': name,
                    'price': price,
                    'category': _selectedCategory,
                    'qty': qty,
                    'img_url': img_url,
                    'description': description,
                    'barcode': barcode
                  }).then((value) => {Get.offAll(() => MenuList())});
                } catch (e) {
                  print("error: " + e.toString());
                }
              }
              print("Error Enter all field");
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '1',
                ),
                keyboardType: TextInputType.text,
              ),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedCategory,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Item name',
                ),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _qtyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quantity',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        pasteFromClipboard();
                      },
                      child: Icon(Icons.paste)),
                  labelText: 'Image URL',
                ),
              ),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                maxLines: null,
              ),
              TextField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Barcode',
                  suffixIcon: Icon(Icons.camera_enhance),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  clearFromField();
                },
                child: Text('Clear Field'),
              ),
            ].insertBetweenAll(SizedBox(height: 10)),
          ),
        ),
      ),
    );
  }

  void clearFromField() {
    _nameController.text = '';
    _priceController.text = '';
    _qtyController.text = '';
    _imageController.text = '';
    _descController.text = '';
    _barcodeController.text = '';
    setState(() {
      _selectedCategory = list.first;
    });
  }

  void pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      _imageController.text = clipboardData.text!;
    }
  }
}

// spacing between columns ========================
extension on List<Widget> {
  List<Widget> insertBetweenAll(Widget widget) {
    var result = List<Widget>.empty(growable: true);
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) {
        result.add(widget);
      }
    }
    return result;
  }
}
