import 'package:flutter/material.dart';
import 'package:practica6_dismov/modelos/tienda.dart';
import 'package:practica6_dismov/paginas/intro_page.dart';
import 'package:practica6_dismov/paginas/shop_cart.dart';
import 'package:practica6_dismov/paginas/shop_page.dart';
import 'package:practica6_dismov/paginas/ticket_page.dart';
import 'package:practica6_dismov/themes/light_mode.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => Shop(),
          child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
      theme: lightmode,
      routes: {
        '/intro_page':(context) => const IntroPage(),
        '/shop_page':(context) => const ShopPage(),
        '/ticket_page':(context) => const MyTicketView(),
        '/shop_cart':(context) => const CartPage(),
      },
    );
  }
}