import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';



class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.product.image,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Text(widget.product.name, style: TextStyle(fontSize: 24)),
            Text('Code: ${widget.product.code}', style: TextStyle(fontSize: 20)),
            Text('\$${widget.product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity:', style: TextStyle(fontSize: 20)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                    ),
                    Text(quantity.toString(), style: TextStyle(fontSize: 20)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Cart.addToCart(widget.product, quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.product.name} added to cart!')),
                );
                Navigator.pop(context);
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}