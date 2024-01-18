import 'package:bom_hamburguer/domain/enum/payment_method_enum.dart';
import 'package:bom_hamburguer/domain/model/product.dart';

class Order {
  late List<Product> products = [];
  late double total = 0.00;
  late double subTotal = 0.00;
  late double discount = 0.00;
  late int discountPercentage = 0;
  late String customerName = '';
  late PaymentMethod paymentMethod;
}