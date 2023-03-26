import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseapp/views/storepage/menu/add_menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/rest_tables.dart';

class CartPage extends StatefulWidget {
  final ResTable resTables;

  const CartPage({super.key, required this.resTables});

  @override
  State<CartPage> createState() => _CartPageState();
}

String _SelectedCategoryName = 'Tea';

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cart Page'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.credit_card),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.print),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              color: Color.fromARGB(255, 85, 66, 4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.resTables.tableName,
                      style: TextStyle(
                          color: Color.fromARGB(255, 253, 250, 250),
                          fontSize: 20),
                    ),
                    Text(
                      "Rs 370",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20),
                    ),
                  ],
                ),
              )),
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            height: MediaQuery.of(context).size.height / 2.5,
            child: CartTable(),
          ),
          Container(
              color: Color.fromRGBO(128, 12, 12, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Menu",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    MenuIconR(),
                  ],
                ),
              )),
          Expanded(
            child: Container(
                color: Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Container(
                        color: Colors.red,
                        width: 130,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("categories")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("something error");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                  var name = snapshot.data?.docs[index]
                                      ['category_name'];

                                  return Container(
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _SelectedCategoryName = name;
                                            });
                                            print(name);
                                          },
                                          child: Card(
                                            child: ListTile(
                                              title: Text(
                                                name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
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
                        )),
                    ShowItems(),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class ShowItems extends StatefulWidget {
  const ShowItems({
    super.key,
  });

  @override
  State<ShowItems> createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("menu_items")
          .where("category", isEqualTo: _SelectedCategoryName)
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
              var name = snapshot.data?.docs[index]['item_name'];
              var category = snapshot.data?.docs[index]['category'];
              var image = snapshot.data?.docs[index]['img_url'];
              var price = snapshot.data?.docs[index]['price'];

              if (image == null || image.isEmpty) {
                return Center(child: CupertinoActivityIndicator());
              }
              return Container(
                child: Column(
                  children: [
                    ListTile(
                        leading: CircleAvatar(
                          child: image != null
                              ? Image.network(
                                  image,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    // Return an ErrorWidget when the image fails to load
                                    return const Icon(Icons.error);
                                  },
                                )
                              : const Icon(Icons.image),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          category,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text("Rs ${price}",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Divider(
                      height: 0,
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

class CartTable extends StatelessWidget {
  const CartTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(.5),
          3: FlexColumnWidth(.5),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
        },
        children: [
          _buildTableRow(['Item', 'Price', 'Qty', 'Edit', 'Add', 'Total']),
          _buildTableRow([
            'Choumin',
            '120',
            '1',
            Icon(Icons.edit),
            Icon(Icons.add),
            '120'
          ]),
          _buildTableRow(
              ['Banda', '250', '1', Icon(Icons.edit), Icon(Icons.add), '250']),
        ],
      ),
    );
  }

  static TableRow _buildTableRow(List<dynamic> data) {
    return TableRow(
      children: data
          .map((cellData) => TableCell(
                child: cellData is Icon
                    ? IconButton(icon: cellData, onPressed: () {})
                    : Text('$cellData'),
              ))
          .toList(),
    );
  }
}

class MenuIconR extends StatelessWidget {
  const MenuIconR({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(spacing: 15, children: <Widget>[
        Icon(
          Icons.camera_enhance,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          color: Colors.white,
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => AddMenuItem());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        Icon(
          Icons.info_outline,
          color: Colors.white,
        ),
        Icon(
          Icons.menu,
          color: Colors.white,
        ),
        Icon(
          Icons.close,
          color: Colors.white,
        ),
      ]),
    );
  }
}
