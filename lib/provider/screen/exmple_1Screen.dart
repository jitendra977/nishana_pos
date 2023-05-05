import 'package:flutter/material.dart';
import 'package:nishanapos/provider/providers/example_1Provider.dart';
import 'package:provider/provider.dart';

import 'exwidget.dart';

class ExampleOne extends StatefulWidget {
  const ExampleOne({super.key});

  @override
  State<ExampleOne> createState() => _ExampleOneState();
}

class _ExampleOneState extends State<ExampleOne> {
  @override
  Widget build(BuildContext context) {
    print("build widget-------------------------------------");
    return Scaffold(
      appBar: AppBar(title: const Text("Subscribe")),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        MyValue(),
        Consumer<ExampleOneProvider>(builder: (context, value, child) {
          return Text(
            value.value.toString(),
            style: TextStyle(fontSize: 55),
          );
        }),
        Consumer<ExampleOneProvider>(
          builder: (context, value, child) {
            return Slider(
              min: 0.1,
              max: 1.0,
              value: value.value,
              onChanged: (val) {
                value.setValue(val);
              },
            );
          },
        ),
        Consumer<ExampleOneProvider>(
          builder: (context, value, child) {
            return Row(children: [
              Expanded(
                child: Container(
                  height: 100,
                  child: Text("Container 1"),
                  decoration:
                      BoxDecoration(color: Colors.red.withOpacity(value.value)),
                ),
              ),
              Expanded(
                  child: Container(
                child: Text("Container 2"),
                height: 100,
                decoration:
                    BoxDecoration(color: Colors.blue.withOpacity(value.value)),
              ))
            ]);
          },
        )
      ]),
    );
  }
}
