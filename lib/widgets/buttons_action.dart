import 'package:flutter/material.dart';

class ButtonsAction extends StatefulWidget {
  const ButtonsAction({super.key});

  @override
  State<ButtonsAction> createState() => _ButtonsAction();
}

class _ButtonsAction extends State<ButtonsAction> {
  @override
  Widget build(BuildContext context) {
    
      void showAlertDialog() {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Warning!'),
              content: const Text('Invalid order. The order can only contain one sandwich, one fries or one drink'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }

    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.blueAccent,
                        onPressed: showAlertDialog,
                        tooltip: 'Add Product',
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.greenAccent,
                        onPressed: showAlertDialog,
                        tooltip: 'Pay Order',
                        child: const Icon(Icons.attach_money),
                      )
                    ],
                  ),
                ],
              );
  }
}