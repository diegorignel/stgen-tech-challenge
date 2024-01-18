import 'package:flutter/material.dart';

class CustomerName extends StatelessWidget {
  const CustomerName({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 400,
      child: 
      TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Customer Name',
        ),
      ),
    );
  }
}