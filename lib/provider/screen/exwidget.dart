import 'package:flutter/material.dart';
import 'package:nishanapos/provider/providers/example_1Provider.dart';
import 'package:provider/provider.dart';

class MyValue extends StatelessWidget {
  const MyValue({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Consumer<ExampleOneProvider>(
        builder: (BuildContext context, value, Widget? child) {
          double val = double.parse(value.value.toString()) * 10;
          String result = val.toStringAsFixed(0);
          return Text(result.toString(),
              style: TextStyle(color: Colors.white, fontSize: 25));
        },
      )),
      height: 100,
      color: Colors.blue,
    );
  }
}
