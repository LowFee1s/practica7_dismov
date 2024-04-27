import 'package:flutter/material.dart';
import 'package:practica6_dismov/modelos/productos.dart';
import 'package:practica6_dismov/modelos/tienda.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void removeItemFromCart(BuildContext context, Product product){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("¿Desea eliminar este articulo de su cesta?"),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().removetotalcarrito(product.price);
              context.read<Shop>().removeFromCart(product);
            },
            child: Text("Si"),
          ),
        ],
      ),
    );
  }

  void ticket(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("¿Deseas ordenar y comprar el carrito?"),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);

              context.read<Shop>().setcountcarrito(1);
              Navigator.of(context).pushNamed("/ticket_page");

            },
            child: Text("Si"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;
    final totalcarrito = context.watch<Shop>().totalcarrito;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Carrito de Compras"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
                child: cart.length > 0 ? ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                  final item = cart[index];

                  return ListTile(
                    leading: Container(child: CircleAvatar(backgroundImage: NetworkImage(item.image))),
                    title: Text(item.name),
                    subtitle: Text("\$${item.price.toStringAsFixed(2)} MXN"),
                      trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => removeItemFromCart(context, item),
                    ),
                  );

                },) : Align(
                  alignment: Alignment.center,
                  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.warning_outlined, size: 100),
                            Text("No tienes articulos en el carrito.", style: TextStyle(fontSize: 25),),
                          ],)),
                )),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Total: \$", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
                    Text("${totalcarrito.toStringAsFixed(2)} MXN", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: totalcarrito > 0.00 ? () {
                          context.read<Shop>().removeproducttotalcarrito(totalcarrito);
                          context.read<Shop>().removeproductFromCart(cart[0]);
                        } : null,
                        child: Text("Vaciar carrito", style: TextStyle(color: Colors.black))
                    ),
                    ElevatedButton(
                      onPressed: totalcarrito > 0.00 ? () {
                        ticket(context);
                      } : null,
                      child: Text("Comprar carrito", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
          ),
        ],
      ),
    );
  }
}
