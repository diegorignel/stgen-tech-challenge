import 'package:bom_hamburguer/domain/enum/product_type_enum.dart';
import 'package:bom_hamburguer/domain/model/product.dart';

class DummyProducts {
    
  List<Product> getProducts() {
    
      List<Product> products = [
          Product(1, 'X Burger', 5.00, ProductType.sandwich),
          Product(2, 'X Egg', 4.50, ProductType.sandwich),
          Product(3, 'X Bacon', 7.00, ProductType.sandwich),
          Product(4, 'Fries', 2.00, ProductType.fries),
          Product(5, 'Soft Drink', 2.50, ProductType.drink)
      ];

      return products;
  }
}