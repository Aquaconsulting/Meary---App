import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/api/data.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/home.dart';

class CreateDetail extends StatefulWidget {
  CreateDetail(
      {super.key,
      required this.userName,
      required this.userID,
      required this.orderID,
      required this.orderStateID,
      required this.products,
      required this.categories});
  int orderID;
  int userID;
  int orderStateID;
  List<dynamic> products = [];
  List<dynamic> categories = [];
  String userName;
  @override
  State<CreateDetail> createState() => _CreateDetailState();
}

class ListTileItem extends StatefulWidget {
  ListTileItem({
    super.key,
    required this.product,
    required this.orderID,
    required this.orderStateID,
    required this.userID,
  });
  Map product = {};
  int orderID;
  int userID;

  int orderStateID;
  @override
  _ListTileItemState createState() => _ListTileItemState();
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class _ListTileItemState extends State<ListTileItem> {
  int _itemCount = 0;
  double finalPrice = 0.00;
  double currentPrice = 0.00;
  setCounter() {
    details.removeWhere((item) => item.productID == widget.product['id']);
    details.add(OrderDetail(
        widget.orderID,
        widget.orderStateID,
        double.parse(widget.product['price']),
        _itemCount,
        widget.product['id']));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Container(
          width: 100,
          child: Text(widget.product['name']),
        ),
        trailing: SizedBox(
          width: 120,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    // IMPEDISCI DI ANDARE SOTTO ZERO
                    _itemCount == 0 ? null : _itemCount--;
                    // SE IL PRODOTTO E' GIA STATO SELEZIONATO, NON AGGIUNGERLO E AUMENTA\DIMINUISCI SOLO LA QUANTITA'
                    setCounter();

                    // SE IL COUNTER E' A 0 RIMUOVI IL PRODOTTO DALL'ARRAY
                    if (_itemCount == 0) {
                      details.removeWhere(
                          (item) => item.productID == widget.product['id']);
                    }
                  });
                },
              ),
              Text(_itemCount.toString()),
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _itemCount++;
                      // SE IL PRODOTTO E' GIA STATO SELEZIONATO, NON AGGIUNGERLO E AUMENTA\DIMINUISCI SOLO LA QUANTITA'
                      setCounter();
                    });
                  })
            ],
          ),
        ));
  }
}

class OrderDetail {
  int orderID;
  int orderStateID;
  double price;
  int quantity;
  int productID;
  OrderDetail(this.orderID, this.orderStateID, this.price, this.quantity,
      this.productID);

  @override
  String toString() {
    return '{orderID: $orderID, orderStateID: $orderStateID, price: $price, quantity: $quantity, productID: $productID}';
  }
}

class _CreateDetailState extends State<CreateDetail> {
  TextEditingController noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget filterItem(index, index2) {
    if (widget.categories[index]['id'] ==
        widget.products[index2]['category_id']) {
      return ListTileItem(
        product: widget.products[index2],
        orderID: widget.orderID,
        orderStateID: widget.orderStateID,
        userID: widget.userID,
      );
    }
    return Container();
  }

  // List<OrderDetail> details = [];
  addOrderDetail() {
    try {
      Services.addOrderDetail(details, noteController.text).then((result) {
        print(result);
        if (result) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(userID: widget.userID)));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Dettaglio ordine creato con successo'),
          ));
          //SVUOTA ARRAY DEI PRODOTTI
          details = [];
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Qualcosa è andato storto.'),
                    content:
                        const Text('Controlla la tua connessione e riprova.'),
                    actions: [
                      TextButton(
                          onPressed: (() {
                            Navigator.pop(context);
                          }),
                          child: const Text('Chiudi'))
                    ],
                  ));
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#F4F3F3'),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(DateTime.now().toString())
                  ]),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
            ),
            Wrap(
              children: List.generate(
                  widget.categories.length,
                  (index) => InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          height: 170,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          child: Container(
                            decoration: BoxDecoration(
                                color: HexColor('#CDD4D9'),
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                              child: Text(widget.categories[index]['name']),
                            ),
                          ),
                        ),
                      )),
            )
            // Container(
            //   margin: const EdgeInsets.all(14),
            //   child: SingleChildScrollView(
            //       child: Form(
            //           key: _formKey,
            //           child: Column(
            //             children: [
            //               ListView.builder(
            //                   shrinkWrap: true,
            //                   scrollDirection: Axis.vertical,
            //                   padding: const EdgeInsets.all(8),
            //                   itemCount: widget.categories.length,
            //                   itemBuilder: (BuildContext context, int index) {
            //                     return Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           widget.categories[index]['name'],
            //                           style: const TextStyle(
            //                               fontSize: 20, fontWeight: FontWeight.w700),
            //                         ),
            //                         Wrap(
            //                           children: List.generate(widget.products.length,
            //                               (index2) => filterItem(index, index2)),
            //                         )
            //                       ],
            //                     );
            //                   }),
            //               Container(
            //                 margin: const EdgeInsets.only(top: 20),
            //                 child: TextFormField(
            //                   decoration: const InputDecoration(
            //                     border: OutlineInputBorder(),
            //                     hintText: 'Inserire Dettagli comanda...',
            //                   ),
            //                   keyboardType: TextInputType.multiline,
            //                   maxLines: 4,
            //                   controller: noteController,
            //                   validator: (value) {
            //                     if (value!.isEmpty) {
            //                       return 'Compila questo campo';
            //                     }
            //                   },
            //                 ),
            //               )
            //             ],
            //           ))),
            // ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     if (_formKey.currentState!.validate()) {
            //       addOrderDetail();
            //       _formKey.currentState!.save();
            //       //funzione per chiudere la tastiera automaticamente
            //       FocusManager.instance.primaryFocus?.unfocus();
            //     }
            //   },
            //   child: const Icon(Icons.add),
            // ),
          ]),
        ));
  }
}
