import 'package:bom_hamburguer/common/dummy_products.dart';
import 'package:bom_hamburguer/domain/model/order.dart';
import 'package:bom_hamburguer/domain/model/product.dart';
import 'package:flutter/material.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({super.key, required this.order});

  final Order order;

  @override
  State<ProductsTable> createState() => _ProductsTable();
}

class _ProductsTable extends State<ProductsTable> {
  @override
  Widget build(BuildContext context) {
    
  var products = DummyProducts().getProducts();


  void removeProductOrder(int id) {
    setState(() {
        Product? product = products.where((p) => p.id == id).first;
        widget.order.products.remove(product);
    });
  }

  return DataTable(
              columns: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Remove'))], 
              rows: widget.order.products.map((row) => DataRow(
                                          cells: [
                                            DataCell(Text(row.id.toString())),
                                            DataCell(Text(row.description)),
                                            DataCell(Text(row.price.toString())),
                                            DataCell(IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () => removeProductOrder(row.id))),
                                          ])).toList()
        );
}
}