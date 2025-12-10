import 'package:flutter/material.dart';
import 'package:newflutter/pages/login.dart';
import 'package:newflutter/pages/ProductsPage.dart';

import 'cartPage.dart';
import 'customer_service.dart';



class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/9.webp"),
                      fit: BoxFit.cover),),

                currentAccountPicture: CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage("assets/image/p.webp"),
                ),

                accountName: Text('Rofaidah',style: TextStyle(color: Colors.white),),
                accountEmail: Text("rofaidah1@gmail.com"))
            ,    ListTile(
                title: Text("Admin Page"),
                leading: Icon(Icons.account_circle,color: Colors.blue),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowProductsPage(isAdmin: true)),
                  );
                }

            ),
            ListTile(
                title: Text("Login"),
                leading: Icon(Icons.login,color: Colors.blue),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
            ),

            ListTile(
                title: Text("Cart"),
                leading: Icon(Icons.add_shopping_cart,color: Colors.blue),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                }
            ),



            ListTile(
                title: Text("Customer Service"),
                leading: Icon(Icons.chat_sharp,color: Colors.blue,),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage()),
                  );
                }
            ),

          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Stack(
                children: [
                  Positioned(bottom: 26,
                    child: Container(
                      child: Text("+1"),
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          color: Colors.blue[200],shape: BoxShape.circle
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                    icon: Icon(Icons.shopping_cart, color: Colors.black),
                  ),


                ],
              )
              ,Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text("\$ 100",style: TextStyle(fontSize: 18,color: Colors.black),)
              )

            ],
          )
        ],
        backgroundColor: Colors.blue[500],
        title: Text('Home'),

      ),
      body: ShowProductsPage(isAdmin: false),
    );
  }
}























