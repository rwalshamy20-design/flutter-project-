import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart.dart';
import '../models/product.dart';
import 'updateProductPage.dart';
import 'productDetailPage.dart';
import 'addProduct.dart';

class ShowProductsPage extends StatelessWidget {
  final bool isAdmin;

  ShowProductsPage({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('Products'),
        actions: isAdmin
            ? [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProduct(),
                ),
              );
            },
          ),
        ]
            : null,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


            print('Document Data: $data');


            String productName = data['name'] is String ? data['name'] : 'Unknown';
            String productCode = data['code'] is String ? data['code'] : 'Unknown';
            String productImage = data['image'] is String ? data['image'] : '';


            double productPrice = 0.0;
            if (data['price'] is double) {
              productPrice = data['price'];
            } else if (data['price'] is String) {
              productPrice = double.tryParse(data['price']) ?? 0.0;
            }


            int productQuantity = data['quantity'] is int ? data['quantity'] : 0;

            return Product(
              id: doc.id,
              name: productName,
              code: productCode,
              image: productImage,
              price: productPrice,
              quantity: productQuantity,
            );
          }).toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (!isAdmin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(product: products[index]),
                      ),
                    );
                  }
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(products[index].image,
                          height: 100, fit: BoxFit.cover),
                      SizedBox(height: 8),
                      Text(products[index].name,
                          style: TextStyle(fontSize: 10)),
                      Text('Code: ${products[index].code}',
                          style: TextStyle(fontSize: 14)),
                      Text(
                        '\$${products[index].price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14),
                      ),
                      if (isAdmin) ...[
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateProductPage(product: products[index]),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await deleteProductFromFirebase(
                                products[index].id, context);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> deleteProductFromFirebase(
      String productId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      removeFromCart(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted from Firebase and Cart!')),
      );
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product')),
      );
    }
  }

  void removeFromCart(String productId) {
    Cart.cartItems.removeWhere((item) => item.product.id == productId);
  }
}