import 'package:flutter/material.dart';
import 'package:practica6_dismov/components/button.dart';

  class IntroPage extends StatelessWidget {
    const IntroPage({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.shopping_basket,
                  size: 75,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                const SizedBox(height: 20),

                //Titulos
                Text(
                  "¡Bienvenido!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),

                const SizedBox(height: 10), //espaciado

                //Subtitulo
                Text(
                  "Miles de Productos a tu Alcance",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                const SizedBox(height: 45),

                //Boton
                MyButton(
                    onTap: () => Navigator.pushNamed(context, '/shop_page'),
                    child: const Icon(Icons.arrow_forward))
              ],
            )
          )
      );
    }
  }


