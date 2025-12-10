import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';
import 'ProductState.dart';

class ProductLogic extends Cubit<ProductState> {
  List products = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  ProductLogic() : super(InitProduct()) {}

  Future<void> insertProduct(String filePath, BuildContext context) async {
    Reference ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      await ref.putFile(File(filePath));
      String downloadURL = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('products').add({
        'name': nameController.text,
        'code': codeController.text,
        'image': downloadURL,
        'price': double.parse(priceController.text),
        'quantity': int.parse(quantityController.text),
      });
      emit(InsertProduct());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded and product added!')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image')),
      );
    }
  }

  getUpdateData(Product product) {
    nameController.text = product.name;
    codeController.text = product.code;
    priceController.text = product.price.toString();
    quantityController.text = product.quantity.toString();
    emit(GetUpdateData());
  }

  Future<void> updateProduct(BuildContext context, Product product) async {

    try {
      await FirebaseFirestore.instance.collection('products').doc(product.id).update({
        'name': nameController.text,
        'code': codeController.text,
        'price': double.parse(priceController.text),
        'quantity': int.parse(quantityController.text),
      });

      emit(UpdateProduct());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error updating product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product')),
      );
    }
  }

  Future<void> deleteProduct(
      String productId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();

      emit(DeleteProduct());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted from Firebase!')),
      );
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product')),
      );
    }
  }

  Future<void> getProducts() async {
    CollectionReference productsTable = FirebaseFirestore.instance.collection('products');

    QuerySnapshot snapshot = await productsTable.get();

    products = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unknown',
        'code': data['code'] ?? 'Unknown',
        'image': data['image'] ?? '',
        'price': (data['price'] ?? 0.0) as double,
        'quantity': (data['quantity'] ?? 0) as int,
      };
    }).toList();
    emit(GetProducts());
  }
}