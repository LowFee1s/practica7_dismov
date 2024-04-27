import 'package:flutter/material.dart';
import 'package:practica6_dismov/components/tiles.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
                children: [
                DrawerHeader(
                child: Center(
                  child: Icon(Icons.shopping_bag,
                  size: 70,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              ),

              const SizedBox(height: 25),

              //Lista de Tiles
              MyListTile(
              text: "Tienda",
              icon: Icons.home,
              onTap: () => Navigator.pop(context),
              ),

              //Carrito
              MyListTile(
              text: "Carrito",
              icon: Icons.shopping_cart,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/shop_cart');
              },
              ),],),


          //Exit
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              text: "Logout",
              icon: Icons.logout,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/intro_page', (route) => false),
            ),
          ),
        ],
      ),
    );
  }
}
