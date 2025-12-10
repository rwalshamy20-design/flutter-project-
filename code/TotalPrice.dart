import 'package:flutter/material.dart';
import 'package:newflutter/pages/paymentPage.dart';
import '../models/cart.dart';

class TotalPrice extends StatefulWidget {
  @override
  State<TotalPrice> createState() => _TotalPriceState();
}

class _TotalPriceState extends State<TotalPrice> {

  @override
  Widget build(BuildContext context) {

    double totalPrice = Cart.cartItems.fold(0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Total Price'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                  ],
                  rows: Cart.cartItems.map((cartItem) {
                    final product = cartItem.product;
                    return DataRow(cells: [
                      DataCell(Text(product.name)),
                      DataCell(Text(cartItem.quantity.toString())),
                      DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),


        ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PaymentPage()),
    );
    },
    child:Text('NEXT ', style: TextStyle(color: Colors.black87)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 170, vertical: 15),
          ),
    ),


          ],
        ),
      ),
    );
  }
}