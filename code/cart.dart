import 'package:newflutter/models/product.dart';

class Cart {
  static List<CartItem> cartItems = [];

  static void addToCart(Product product, int quantity) {
    CartItem? existingItem = cartItems.firstWhere(
          (item) => item.product.code == product.code,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity += quantity;
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }
  }
  static void removeFromCart(CartItem cartItem) {
    cartItems.remove(cartItem);
  }
}

class CartItem {
  final Product product;
  int quantity;


  CartItem({required this.product, required this.quantity});
}