import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:practica6_dismov/modelos/productos.dart';
import 'package:url_launcher/url_launcher.dart';

class Shop extends ChangeNotifier {

  List<Product> _shop = [];
  List<Product> _cart = [];
  bool filtrar = false;
  double _totalcarrito = 0.00;
  int _countcarrito = 10000;

  Shop() {
   loadAllProducts();
  }

  void loadAllProducts() async {
    ReceivePort receivePort = ReceivePort();
    Isolate.spawn(getAllProducts, receivePort.sendPort);
    receivePort.listen((data) {
      _shop = data;
      notifyListeners();
    });
  }

  static void getAllProducts(SendPort sendPort) async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<Product> products = List<Map<String, dynamic>>.from(data).map((producto) => Product(
        id: producto['id'],
        name: producto['title'],
        price: double.parse(producto['price'].toString()),
        category: producto['category'],
        description: producto['description'],
        image: producto['image'],
      )).toList();
      sendPort.send(products);
    } else {
      throw Exception("Error al cargar los productos. ");
    }

  }

Future<String> get summary async {

var productLines = cart.asMap().entries.map((item11) {
  int index = item11.key;
  var item = item11.value;
  return '${index + 1}.- ${item.name} - ${item.price.toStringAsFixed(2)} MXN';
}).join('\n\n');

return '''
-Pedido comprado-

Total: $totalcarrito MXN
Fecha de pedido: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

Lista de Productos - ${cart.length}


$productLines
 
 
Elaboro: Equipo 4
Practica 7

Gracias por la compra!
''';

}

  Future<bool> sendOrder11() async {
    var output = await getExternalStorageDirectory();
    final Email email = Email(
      body: await summary,
      subject: 'Orden de compra FIME EQUIPO 4',
      recipients: [],
      attachmentPaths: ['${output!.path}/${countcarrito}ticket.pdf'],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
      return true;
    } catch (error11) {
      print("No se envio el correo correctamente: $error11");
      return false;
    }
  }

  Future<bool> sendOrder() async {

    Uri uri = Uri.parse('mailto:?subject=Orden de compra FIME EQUIPO 4&body=${await summary}');
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    return true;
  }

  //lista de productos
  List<Product> get shop => _shop;
  //carrito lleno
  List<Product> get cart => _cart;
  int get countcarrito => _countcarrito;
  double get totalcarrito => _totalcarrito;
  //añadir articulos
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners();
  }

  void settotalcarrito(double item) {
    _totalcarrito += item;
    notifyListeners();
  }

  void setcountcarrito(int item) {
    _countcarrito += item;
    notifyListeners();
  }

  void removetotalcarrito(double item) {
    _totalcarrito -= item;
    notifyListeners();
  }

  void removeproducttotalcarrito(double item) {
    _totalcarrito = 0.00;
    notifyListeners();
  }

  void removeproductFromCart(Product item) {
    _cart = [];
    notifyListeners();

  }

  //eliminar articulo
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners();

  }

}