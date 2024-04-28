import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:provider/provider.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../modelos/tienda.dart';

class MyTicketView extends StatelessWidget {
  const MyTicketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();



    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket del carrito"),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Center(
          child: TicketWidget(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.85,
            isCornerRounded: true,
            padding: EdgeInsets.all(15),
            child: TicketData(),
          ),
        ),
      ),
    );
  }
}




class TicketData extends StatefulWidget {
  const TicketData({
    Key? key,
  }) : super(key: key);

  _TicketData createState() => _TicketData();
}

class _TicketData extends State<TicketData> {

  @override
  Widget build(BuildContext context) {
    var totalcarrito = context.watch<Shop>().totalcarrito;
    var countcarrito = context.watch<Shop>().countcarrito;
    bool isloading = false;
    var carrito = context.watch<Shop>().cart;

    Future<void> generatePDF() async {
      setState(() {
        isloading = true;
      });
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Ticket de Productos', style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Fecha: ${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}', style: pw.TextStyle(fontSize: 20)),
                  pw.Text('Orden: #${countcarrito.toString()}', style: pw.TextStyle(fontSize: 20)),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Productos: ${carrito.length.toString()}', style: pw.TextStyle(fontSize: 20)),
                  pw.Text('Orden del carrito', style: pw.TextStyle(fontSize: 20)),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
              pw.Table(
                columnWidths: {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                      children: [
                        pw.Text("Producto", style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Precio", style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold)),
                      ]
                  ),
                  ...carrito.map((producto) => pw.TableRow(children: [
                    pw.Text(producto.name, style: pw.TextStyle(fontSize: 17)),
                    pw.Text("\$${producto.price.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold)),
                  ]
                  )).toList(),
                ],
              ),
              pw.Padding(padding: const pw.EdgeInsets.only(top: 41)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Equipo 4 - Fime', style: pw.TextStyle(fontSize: 21, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(width: 17),
                  pw.Text('Total: \$${totalcarrito.toStringAsFixed(2)} MXN', style: pw.TextStyle(fontSize: 21, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      );

      // Obtén la ruta del directorio donde quieres guardar el archivo
      final output = await getExternalStorageDirectory();
      final file = File("${output!.path}/${countcarrito}ticket.pdf");

      // Guarda el PDF
      await file.writeAsBytes(await pdf.save());
      setState(() {
        isloading = false;
      });
      var email = context.read<Shop>().sendOrder();


      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("/shop_page");


      context.read<Shop>().removeproducttotalcarrito(totalcarrito);
      context.read<Shop>().removeproductFromCart(carrito[0]);

      Flushbar(
        titleText: Text("Pedido realizado correctamente", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.white)),
        messageText: Text("Se realizo el pedido y el envio del ticket con los detalles correctamente. ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.031, color: Colors.white)),
        duration: Duration(seconds: 17),
        backgroundColor: Colors.green,
        borderRadius: BorderRadius.circular(21),
        maxWidth: MediaQuery.of(context).size.width * 1,
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        shouldIconPulse: false,
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        padding: EdgeInsets.all(21),
        icon: Icon(Icons.check, color: Colors.white),
      )..show(context);

    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: Center(
                child: Text(
                  '#${countcarrito.toString()}',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            const Row(
              children: [
                Text(
                  'FIME',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'EQUIPO 4',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Orden del carrito',
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ticketDetailsWidget('Productos', '${carrito.length}', 'Fecha', '${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}'),
            ],
          ),
        ),

        Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Total del carrito: ',
                      style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      '\$${totalcarrito.toStringAsFixed(2)} MXN',
                      style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ]
        ),

        Center(
          child: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(textAlign: TextAlign.center, 
              'Productos',
              style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: carrito.length,
            itemBuilder: (context, index) {
            final item = carrito[index];

            return ListTile(
              leading: Container(child: CircleAvatar(backgroundImage: NetworkImage(item.image))),
              title: Text(item.name),
              subtitle: Text("\$${item.price.toStringAsFixed(2)}"),
            );
          }

          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)), onPressed: () => Navigator.of(context).pushReplacementNamed('/shop_cart'), child: Text("Cancelar", style: TextStyle(fontSize: 17, color: Colors.white))),
            ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)), onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text("¿Seguro que quieres comprar y enviar el ticket del carrito?"),
                    actions: [
                      MaterialButton(
                      onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        generatePDF();
                      },
                      child: Text("Si"),
                      ),
                    ],
                  ),
                );

              },
              child: isloading ? Center(child: CircularProgressIndicator()) : Text("Confirmar", style: TextStyle(fontSize: 17, color: Colors.white))),
          ],
        ),

      ],
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc, String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}