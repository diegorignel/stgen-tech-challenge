import 'package:bom_hamburguer/common/dummy_products.dart';
import 'package:bom_hamburguer/domain/enum/payment_method_enum.dart';
import 'package:bom_hamburguer/domain/enum/product_type_enum.dart';
import 'package:bom_hamburguer/domain/model/order.dart';
import 'package:bom_hamburguer/domain/model/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.title});

  final String title;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

final textController = TextEditingController();
PaymentMethod? paymentMethod = PaymentMethod.money;

var products = DummyProducts().getProducts();
Order order = Order();

Product? selectedProduct;

void setSelectedProduct(Product? value) {
      setState(() {
      selectedProduct = value;
    });
}

void removeProductOrder(int id) {
    setState(() {
        Product? product = products.where((p) => p.id == id).first;
        order.subTotal -= product.price;
        order.products.remove(product);
        calculateOrder(order.subTotal);
    });
}

void resetTable() {
  setState(() {
    order.products.clear();
  });
}

void addProductToOrder() {
    setState(() {

      if(selectedProduct == null) {
        showWarningDialog('Please select a product to add to order');
      } else {
        bool isValid = validateOrder(selectedProduct!);
        if(isValid) {
          order.products.add(selectedProduct!);
          order.subTotal += selectedProduct!.price;
          calculateOrder(order.subTotal);
        } else {
          showWarningDialog('Invalid order. The order can only contain one sandwich, one fries or one drink');
        }
      }
    });
}

bool validateOrder(Product product) {

    bool valid = false;

    int sandwichCounter = order.products.where((p) => p.productType == ProductType.sandwich).length;
    int friesCounter = order.products.where((p) => p.productType == ProductType.fries).length;
    int drinkCounter = order.products.where((p) => p.productType == ProductType.drink).length;

    if(product.productType == ProductType.sandwich && sandwichCounter == 0) {
        valid = true;
    }

    if(product.productType == ProductType.fries && friesCounter == 0) {
      valid = true;
    }

    if(product.productType == ProductType.drink && drinkCounter == 0) {
      valid = true;
    }

    return valid;
  }

void calculateOrder(double price) {

    int discount = 0;

    bool hasSandwich = order.products.where((p) => p.productType == ProductType.sandwich).isNotEmpty;
    bool hasFries = order.products.where((p) => p.productType == ProductType.fries).isNotEmpty;
    bool hasDrink = order.products.where((p) => p.productType == ProductType.drink).isNotEmpty;

    if(hasSandwich && hasDrink && hasFries) {
      discount = 20;
    } else {
      if(hasSandwich && hasDrink) {
        discount = 15;
      } else {
        if(hasSandwich && hasFries) {
          discount = 10;
        }
      }
    }

    order.discountPercentage = discount;
    order.discount = price * (discount / 100);
    order.total = price - order.discount;
  }

void showWarningDialog(String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Warning!'),
        content: Text(message),
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

void showPaymentDialog() {

showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
          title: const Text('Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min, 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              ListTile(
                title: const Text('Money'),
                leading: Radio<PaymentMethod>(
                  value: PaymentMethod.money,
                  groupValue: paymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Credit Card'),
                leading: Radio<PaymentMethod>(
                  value: PaymentMethod.creditCard,
                  groupValue: paymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
              ),

              ListTile(
                title: const Text('Debit Card'),
                leading: Radio<PaymentMethod>(
                  value: PaymentMethod.debitCard,
                  groupValue: paymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
              ),

              Card(
                  child: SizedBox(
                    width: 300,
                    height: 83,
                    child: Center(
                              child: 
                                Column(
                                  children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <TextSpan> [
                                        const TextSpan(text: 'Customer: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: order.customerName),
                                      ],
                                    )
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: <TextSpan> [
                                        const TextSpan(text: 'Discount: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: '\$ ${order.discount.toStringAsFixed(2)}'),
                                      ],
                                    )
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: <TextSpan> [
                                        const TextSpan(text: 'Sub Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: '\$ ${order.subTotal.toStringAsFixed(2)}'),
                                      ],
                                    )
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: <TextSpan> [
                                        const TextSpan(text: 'Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: '\$ ${order.total.toStringAsFixed(2)}'),
                                      ],
                                    )
                                  )
                                  ],
                                )
                                
                    ),
                  )
                ),
            ]
        ),
        actions: [
            TextButton(
              onPressed: () => confirmPayment(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
      )
    )
  );
}

bool validatePayment(Order order) {
   
   bool valid = false;
   var customerName = textController.text;
   
   bool hasCustomerName = customerName.isNotEmpty;
   if(hasCustomerName) {
      order.customerName = customerName;
   }
   
  bool hasProducts = order.products.isNotEmpty;

  valid = hasCustomerName && hasProducts;

   return valid;
}

void payOrder() {
  bool isValid = validatePayment(order);
  if(isValid) {
     showPaymentDialog();
  } else {
    showWarningDialog('Invalid order. Please verify customer name and order items.');
  }
}

void confirmPayment() {
  order.paymentMethod = paymentMethod!;
  Navigator.pop(context);
  restartOrder();
  resetTable();
}

Future<void> saveOrder(Order order) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("myOrder", order.toString());
}

void restartOrder() {
  textController.text = '';
  paymentMethod = PaymentMethod.money;
  order = Order();
  selectedProduct = null;

}

void showProducts() {

var products = DummyProducts().getProducts();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
          title: const Text('Products'),
          content: Column(
            mainAxisSize: MainAxisSize.min, 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                            DataTable(
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Price'))], 
                rows: products.map((row) => DataRow(
                                            cells: [
                                              DataCell(Text(row.id.toString())),
                                              DataCell(Text(row.description)),
                                              DataCell(Text(row.price.toString())),
                                            ])).toList()
              ),
            ]
        ),
        actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
      )
    )
  );
}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[

              SizedBox(
                width: 400,
                child: 
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Customer Name',
                  ),
                ),
              ),
              DropdownButton<Product>(items: products.map((product) => DropdownMenuItem<Product>(value: product, child: Text(product.description))).toList(), 
                                    value: selectedProduct,
                                    onChanged: (Product? value) {  
                                    setSelectedProduct(value);
                                    },
                                    hint: const Text('Choose products to add to order'),
              ),
                                  
              
              DataTable(
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Remove'))], 
                rows: order.products.map((row) => DataRow(
                                            cells: [
                                              DataCell(Text(row.id.toString())),
                                              DataCell(Text(row.description)),
                                              DataCell(Text(row.price.toString())),
                                              DataCell(IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () => removeProductOrder(row.id))),
                                            ])).toList()
              ),


              Card(
                child: SizedBox(
                  width: 300,
                  height: 60,
                  child: Center(
                            child: 
                              Column(
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <TextSpan> [
                                        const TextSpan(text: 'Discount: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: '\$ ${order.discount.toStringAsFixed(2)}'),
                                      ],
                                    )
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: <TextSpan> [
                                        const TextSpan(text: 'Sub Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: '\$ ${order.subTotal.toStringAsFixed(2)}'),
                                      ],
                                    )
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: <TextSpan> [
                                        const TextSpan(text: 'Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: '\$ ${order.total.toStringAsFixed(2)}'),
                                      ],
                                    )
                                  )
                                ],
                              )
                              
                          ),
                )
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FloatingActionButton(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        onPressed: addProductToOrder,
                        tooltip: 'Add Product',
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      FloatingActionButton(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        onPressed: payOrder,
                        tooltip: 'Pay Order',
                        child: const Icon(Icons.attach_money),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      FloatingActionButton(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        onPressed: showProducts,
                        tooltip: 'Products',
                        child: const Icon(Icons.shopping_cart),
                      )
                    ],
                  ),
                ],
              )
           ],
        ),
      ),
    );
  }
}