import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'TotalPrice.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Cart.cartItems.length,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  cartItem: Cart.cartItems[index],
                  onRemove: () {
                    setState(() {
                      Cart.removeFromCart(Cart.cartItems[index]);
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Payment page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TotalPrice()),
                );
              },
              child: Text(
                'Check Out',
                style: TextStyle(color: Colors.black87),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;

  CartItemWidget({required this.cartItem, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    final totalPrice = product.price * cartItem.quantity;

    return ListTile(
      leading: Image.network(
        product.image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('\$${totalPrice.toStringAsFixed(2)}'),
          Text('Quantity: ${cartItem.quantity}'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          onRemove();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} removed from cart.')),
          );
        },
      ),
    );
  }
}