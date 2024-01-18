import 'package:bom_hamburguer/common/dummy_products.dart';
import 'package:bom_hamburguer/domain/model/product.dart';
import 'package:flutter/material.dart';

class ProductsSelect extends StatefulWidget {
  const ProductsSelect({super.key});

  @override
  State<ProductsSelect> createState() => _ProductsSelect();
}

class _ProductsSelect extends State<ProductsSelect> {
  @override
  Widget build(BuildContext context) {
    
  Product? selectedProduct;
  var products = DummyProducts().getProducts();

    void setSelectedProduct(Product? value) {
      setState(() {
      selectedProduct = value;
    });
  }
    
  return DropdownButton<Product>(items: products.map((product) => DropdownMenuItem<Product>(value: product, child: Text(product.description))).toList(), 
                                    value: selectedProduct,
                                    onChanged: (Product? value) {  
                                      setSelectedProduct(value);
                                    },
                                    
    );
  }
}
