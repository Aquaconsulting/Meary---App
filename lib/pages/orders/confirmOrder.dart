import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/home.dart';
import 'package:meari/pages/orders/filterProducts.dart';

class ConfirmOrder extends StatefulWidget {
  ConfirmOrder(
      {super.key,
      required this.orderDetail,
      required this.order,
      required this.coperti});
  List orderDetail;
  dynamic order;
  int coperti;

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
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

class _ConfirmOrderState extends State<ConfirmOrder> {
  String noteComanda = '';

  double totalPrice = 0;
  getTotalPrice() {
    double orderPrice = 0;
    for (var element in widget.orderDetail) {
      dynamic counter =
          double.parse(element['price'].toString()) * element['quantity'];
      orderPrice = counter + orderPrice;
    }
    return orderPrice;
  }

  getProductsMinutes(x) {
    for (var element in products) {
      if (element['id'] == x['product_id']) {
        return element['tempo_preparazione'];
      }
    }
  }

  getProductName(x) {
    for (var element in products) {
      if (element['id'] == x['product_id']) {
        return element['name'];
      }
    }
  }

  getProductImage(orderDetail) {
    for (var element in products) {
      if (element['id'] == orderDetail['product_id']) {
        return element['image'];
      }
    }
  }

  updateOrderDetail() {
    try {
      Services.updateOrderDetail(widget.orderDetail).then((result) {
        if (result != false) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(userID: userID!)));

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Dettaglio ordine modificato con successo'),
          ));
        } else {
          // SE INVECE RITORNA FALSE MOSTRA QUESTO
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

  addOrderDetail() {
    try {
      Services.addFullOrder(widget.order['user_id'], widget.order['table_id'],
              widget.orderDetail, widget.order['note'])
          .then((result) {
        if (result) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(userID: userID!)));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Dettaglio ordine creato con successo'),
          ));
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

  updateNote() {
    widget.order['note'] = noteComanda;
    setState(() {
      Navigator.pop(context);
    });
    // try {
    //   Services.updateNote(widget.order['id'], widget.order['note'])
    //       .then((result) {
    //     if (result) {
    //       setState(() {
    //         Navigator.pop(context);
    //       });
    //     } else {
    //       showDialog(
    //           context: context,
    //           builder: (context) => AlertDialog(
    //                 title: const Text('Qualcosa è andato storto.'),
    //                 content:
    //                     const Text('Controlla la tua connessione e riprova.'),
    //                 actions: [
    //                   TextButton(
    //                       onPressed: (() {
    //                         Navigator.pop(context);
    //                       }),
    //                       child: const Text('Chiudi'))
    //                 ],
    //               ));
    //     }
    //   });
    // } catch (e) {
    //   return e;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor('#F4F3F3'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 20),
                        backgroundColor: HexColor('#4BC59E')),
                    onPressed: () {
                      print('PRODUCT STATE: ' + product_states.toString());
                      if (widget.orderDetail.isNotEmpty) {
                        //SE LA ROTTA E' UPDATE NON AGGIUNGERE DI NUOVO I COPERTI
                        if (confirmUpdate) {
                          updateOrderDetail();
                        } else {
                          dynamic readyState = product_states
                              .where((element) =>
                                  element['state_colour'] == "#2F2DCF")
                              .toList();
                          //CREA COPERTO CON STATO A PRONTO
                          dynamic finalCoperto = {
                            'order_id': widget.order['id'],
                            'order_state_id': readyState[0]['id'],
                            'price': coperto[0]['price'],
                            'quantity': widget.coperti,
                            'product_id': coperto[0]['id']
                          };
                          // AGGIUNGILO ALLA LISTA DI PRODOTTI
                          print('FINAL COPERTO ${finalCoperto.toString()}');
                          widget.orderDetail.add(finalCoperto);
                          addOrderDetail();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'INVIA COMANDA',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        Image.asset(
                          'assets/images/arrow.png',
                          scale: 1.2,
                        )
                      ],
                    ))),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 20),
                      backgroundColor: HexColor('#43ABFB')),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      idCustomCocktail = [];
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MODIFICA COMANDA',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      Image.asset(
                        'assets/images/pen2.png',
                        scale: 1.2,
                      )
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 20),
                      backgroundColor: HexColor('#FF3131')),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(
                                  'Sei sicuro di voler eliminare questo ordine?'),
                              content:
                                  const Text('Questa azione è irreversibile.'),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            backgroundColor:
                                                HexColor('#FF3131')),
                                        onPressed: () {
                                          try {
                                            Services.deleteOrder(
                                                    widget.order['id'])
                                                .then((result) {
                                              if (result) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home(
                                                                userID:
                                                                    userID!)));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('Ordine eliminato'),
                                                ));
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              'Qualcosa è andato storto.'),
                                                          content: const Text(
                                                              'Controlla la tua connessione e riprova.'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: (() {
                                                                  Navigator.pop(
                                                                      context);
                                                                }),
                                                                child: const Text(
                                                                    'Chiudi'))
                                                          ],
                                                        ));
                                              }
                                            });
                                          } catch (e) {}
                                        },
                                        icon: Image.asset(
                                            'assets/images/cestino.png'),
                                        label: const Text(
                                          'ELIMINA',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    TextButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            backgroundColor:
                                                HexColor('#43ABFB')),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_sharp,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'INDIETRO',
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                )
                              ],
                            ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ELIMINA COMANDA',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      Image.asset(
                        'assets/images/cestino.png',
                        scale: 0.8,
                      )
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 20),
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('INSERISCI NOTE COMANDA.'),
                              content: TextFormField(
                                initialValue: widget.order['note'],
                                maxLines: 10,
                                onChanged: (value) {
                                  noteComanda = value;
                                },
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            backgroundColor:
                                                Colors.green.shade300),
                                        onPressed: () {
                                          // updateNote();
                                          setState(() {
                                            widget.order['note'] = noteComanda;
                                            Navigator.pop(context);
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/images/pen3.png',
                                        ),
                                        label: const Text(
                                          'CONFERMA',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    TextButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_sharp,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'CANCELLA',
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                )
                              ],
                            ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'NOTE COMANDA',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      Image.asset(
                        'assets/images/pen3.png',
                        scale: 1.2,
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: HexColor('#A1C2C5'),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('COMANDA',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 28)),
                        // const Text(' '),
                        // Text(
                        //   'ID-${widget.order['id']}',
                        //   style: const TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w800,
                        //       fontSize: 28),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text('€',
                                  style: TextStyle(
                                      color: HexColor('#43ABFB'),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25)),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTotalPrice().toStringAsFixed(2),
                                      style: TextStyle(
                                          color: HexColor('#43ABFB'),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      'Totale',
                                      style: TextStyle(
                                          color: HexColor('#43ABFB'),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Container(
                        //       margin: const EdgeInsets.symmetric(
                        //           vertical: 12, horizontal: 10),
                        //     ),
                        //     Image.asset('assets/images/redclock.png'),
                        //     Container(
                        //       margin: const EdgeInsets.only(left: 4, right: 12),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             '20:20',
                        //             style: TextStyle(
                        //                 color: HexColor('##FF3131'),
                        //                 fontWeight: FontWeight.w600,
                        //                 fontSize: 12),
                        //           ),
                        //           Text(
                        //             'Tot attesa',
                        //             style: TextStyle(
                        //                 color: HexColor('##FF3131'),
                        //                 fontWeight: FontWeight.w400,
                        //                 fontSize: 9),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    color: HexColor('#F4F3F3'),
                    child: Center(
                      child: Text(
                        widget.orderDetail.isEmpty
                            ? 'Nessun prodotto aggiunto, impossibile inviare la comanda'
                            : 'Tutti i prodotti sono stati aggiunti correttamente alla comanda.',
                        style: TextStyle(
                            fontSize: 20,
                            color: HexColor('#002115'),
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), //IMPORTANTE
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: widget.orderDetail.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                leading: getProductImage(
                                            widget.orderDetail[index]) ==
                                        null
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/logo.png',
                                            scale: 3.4,
                                          )
                                        ],
                                      )
                                    : Image.network(
                                        'https://meari.aquaconsulting.it/img/product/${getProductImage(widget.orderDetail[index])}',
                                      ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        getProductName(
                                                widget.orderDetail[index])
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      'Quantità ${widget.orderDetail[index]['quantity']}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: HexColor('#A1C2C5'),
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                subtitle: Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    '€${widget.orderDetail[index]['price']}',
                                    style: TextStyle(
                                        color: HexColor('#43ABFB'),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // trailing: Column(
                                //   children: [
                                //     Image.asset('assets/images/clock.png'),
                                //     const SizedBox(
                                //       width: 8,
                                //     ),
                                //     Text(
                                //       '${getProductsMinutes(widget.orderDetail[index]) ?? '0'} min.',
                                //       style: TextStyle(
                                //           color: HexColor('#43ABFB'),
                                //           fontWeight: FontWeight.w700),
                                //     )
                                //   ],
                                // ),
                                tileColor: Colors.white,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child:
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
