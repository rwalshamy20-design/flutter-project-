import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc_Cubit/productBloc/ProductLogic.dart';
import '../Bloc_Cubit/productBloc/ProductState.dart';
import '../models/product.dart';



class UpdateProductPage extends StatelessWidget {
  Product product;

  UpdateProductPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>ProductLogic()..getUpdateData(product),
        child: BlocConsumer<ProductLogic, ProductState>(listener: (BuildContext context, state) {  }, builder: (BuildContext context, state) {
          ProductLogic obj = BlocProvider.of(context);
          return Scaffold(
            appBar: AppBar(title: Text('Update Product')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: obj.nameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                  TextField(
                    controller: obj.codeController,
                    decoration: InputDecoration(labelText: 'Product Code'),
                  ),
                  TextField(
                    controller: obj.priceController,
                    decoration: InputDecoration(labelText: 'Product Price'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: obj.quantityController,
                    decoration: InputDecoration(labelText: 'Product Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await obj.updateProduct(context, product);
                    },
                    child: Text('Update Product'),
                  ),
                ],
              ),
            ),
          );
        },)
    );
  }
}
