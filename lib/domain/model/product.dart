import 'package:bom_hamburguer/domain/enum/product_type_enum.dart';

class Product {
  late int id;
  late String description;
  late double price;
  late ProductType productType;

  Product(this.id, this.description, this.price, this.productType);
}