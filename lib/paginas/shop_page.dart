import 'package:flutter/material.dart';
import 'package:practica6_dismov/components/drawer.dart';
import 'package:practica6_dismov/components/item_tile.dart';
import 'package:practica6_dismov/modelos/tienda.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();

}

var categoriafilter;

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {

    final products = context.watch<Shop>().shop;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Tienda"),
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          const SizedBox(height: 25),

          Center(
            child: Text(
              "Seleccionar Items",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),

        SizedBox(
          height: 550,
          child: ListView.builder(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(15),
            itemBuilder: (context, index) {

              final product = products[index];
              return MyProductTile(product: product);
            },
          ),
        )
        ],
      ),
    );
  }
}
