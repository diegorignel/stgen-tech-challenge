import 'package:flutter/material.dart';

class Prices extends StatefulWidget {
  const Prices({super.key});

  @override
  State<Prices> createState() => _Prices();
}

class _Prices extends State<Prices> {
  @override
  Widget build(BuildContext context) {
    
    return  const Card(
                child: SizedBox(
                  width: 300,
                  height: 60,
                  child: Center(
                            child: 
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Discount'
                                    // 'Discount: \$ ${_discount.toStringAsFixed(2)}'
                                  ),
                                  Text(
                                    'Sub Total'
                                    // 'Sub Total: \$ ${_subTotalPrice.toStringAsFixed(2)}'
                                  ),
                                  Text(
                                    'Total'
                                    // 'Total: \$ ${_totalPrice.toStringAsFixed(2)}'
                                  ),
                                ],
                              )
                              
                          ),
                )
              );
  }
}
