import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practica6_dismov/modelos/productos.dart';
import 'package:practica6_dismov/modelos/tienda.dart';
import 'package:provider/provider.dart';

class MyProductTile extends StatelessWidget {
  final Product product;

  const MyProductTile({
    super.key,
    required this.product,
  });

  void addToCart(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("¿Desea añadir este articulo a su cesta?"),
          actions: [
            MaterialButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<Shop>().settotalcarrito(product.price);
                  context.read<Shop>().addToCart(product);
                },
              child: Text("Si"),
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin:  const EdgeInsets.all(10),
      padding: const EdgeInsets.all(25),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(21),
              child: Image.network(product.image),
            ),
          ),

            const SizedBox(height: 11),

            //Nombre del Producto
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

              const SizedBox(height: 7), //Espaciado entre Nombre y Descripcion
              //Descripcion del Producto
              Text(
                product.description.length > 20 ? product.description.substring(0, 50) + "...." : product.description,
                style: TextStyle(
                  overflow: TextOverflow.clip,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
          ],
          ),

          const SizedBox(height: 14),

          // Precio y Añadir al carrito
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$' + product.price.toStringAsFixed(2)),

              //Añadir al carrito
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                    onPressed: () => addToCart(context),
                    icon: const Icon(Icons.add),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
