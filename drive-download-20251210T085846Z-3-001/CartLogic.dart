import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../models/Cart.dart';
import 'CartState.dart';

class ProductLogic extends Cubit<CartState> {
  List carts = [];
  late String name;
  late int userID;
  late double total_price;
  ProductLogic() : super(InitCart()) {}

  Future<void> insertCart(String filePath, BuildContext context) async {
      await FirebaseFirestore.instance.collection('carts').add({
        'name': name,
        'userID': userID,
        'total_price': total_price,
      });

      emit(InsertCart());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cart added!')),
      );

      Navigator.pop(context);
  }

  Future<void> deleteCart(
      String cartID, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cartID)
          .delete();

      emit(DeleteCart());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cart deleted from Firebase!')),
      );
    } catch (e) {
      print('Error deleting cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting cart')),
      );
    }
  }

  Future<void> getCart(CartItem cartItem) async {
    CollectionReference cartsTable = FirebaseFirestore.instance.collection('carts');

    QuerySnapshot snapshot = await cartsTable.get();

    carts = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unknown',
        'total_price': (data['total_price'] ?? 0.0) as double,
        'userID': (data['userID'] ?? 0) as int,
      };
    }).toList();
    emit(GetCart());
  }
}