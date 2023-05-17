import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/components/customDeleteModal.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/chooseCategory.dart';
import 'package:meari/pages/orders/confirmOrder.dart';
import 'package:meari/pages/orders/updateCustomProduct.dart';

class UpdateOrder extends StatefulWidget {
  UpdateOrder({
    super.key,
    required this.order,
    required this.orderDetail,
  });
  dynamic order;
  List orderDetail;
  @override
  State<UpdateOrder> createState() => _UpdateOrderState();
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

class _UpdateOrderState extends State<UpdateOrder> {
  bool value = false;
  void refreshData() {
    setState(() {
      value = true;
    });
  }

  late List coperti = widget.orderDetail
      .where((element) => element['product_id'] == 1)
      .toList();

  getProductsMinutes(x) {
    for (var element in products) {
      if (element['id'] == x['product_id']) {
        return element['tempo_preparazione'];
      }
    }
  }

  getProductName(orderDetail) {
    for (var element in products) {
      if (element['id'] == orderDetail['product_id']) {
        if (orderDetail['custom_product'] != null) {
          for (var element2 in element['category']) {
            return element2['name'];
          }
        }
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

  List customProducts = [];
  getCustomProduct(orderDetail) {
    customProducts = [];
    for (var element in products) {
      for (var element2 in orderDetail['custom_product']) {
        if (element2 == element['id']) {
          customProducts.add(element['name']);
        }
      }
    }
    return customProducts;
  }

  // getProductStateName(int index) {
  //   for (var element in product_states) {
  //     if (element['id'] == widget.orderDetail[index]['order_state_id']) {
  //       return element['state_colour'];
  //     }
  //   }
  // }

  getProductStateColour(int index) {
    for (var element in product_states) {
      print(element['id']);
      print(widget.orderDetail[index]['order_state_id']);
      if (element['id'] == widget.orderDetail[index]['order_state_id']) {
        return element['state_colour'];
      }
    }
  }

  List listID = [];
  @override
  void initState() {
    super.initState();
    for (var element in widget.orderDetail) {
      if (element['custom_product'] is String == true) {
        listID = jsonDecode(element['custom_product']);
        element['custom_product'] = listID;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      loading ? null : Navigator.pop(context, 'refresh');
                    },
                    child: Container(
                      child: Image.asset(
                        'assets/images/back.png',
                        scale: 1.5,
                      ),
                    ),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(today)
                ]),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: const Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: const [
                  Text('COMANDA'),
                  Text(
                    'TAVOLO',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  )
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(width: 1, color: HexColor('#FF3131'))),
                child: Text(
                  currentTable.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: HexColor('#FF3131'),
                      fontWeight: FontWeight.w900),
                ),
              ),
              // ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: HexColor('#43ABFB')),
              //     onPressed: () async {
              //       String refresh = await showDialog(
              //           barrierDismissible: false,
              //           context: context,
              //           builder: (context) => CustomModal(
              //                 orderID: widget.order['id'],
              //               ));
              //       refresh == 'refresh' ? refreshData() : null;
              //     },
              //     child: const Text('CAMBIA TAVOLO')),
              InkWell(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: null,
                          content: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            if (widget.orderDetail.isEmpty) {
                              //CREA VARIABILE CON STATO A PRONTO
                              dynamic readyState = product_states
                                  .where((element) =>
                                      element['state_colour'] == "#2F2DCF")
                                  .toList();
                              dynamic finalCoperto = {
                                'order_id': widget.order['id'],
                                //ASSEGNA QUESTA VARIABILE AL COPERTO
                                'order_state_id': readyState[0]['id'],
                                'price': coperto[0]['price'],
                                'quantity': 0,
                                'product_id': coperto[0]['id']
                              };
                              // AGGIUNGILO ALLA LISTA DI PRODOTTI
                              widget.orderDetail.add(finalCoperto);
                              //E ALLA LISTA CREATA IN PRECEDENZA CHE DETIENE IL COPERTO
                              coperti.add(finalCoperto);
                            }

                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: Column(children: [
                                Text(
                                  "COPERTI: ${coperti[0]['quantity']}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            coperti[0]['quantity']--;
                                          });
                                        },
                                        child: Image.asset(
                                          'assets/images/minus.png',
                                          scale: 1.2,
                                        ),
                                      ),
                                      Text(
                                        '${coperti[0]['quantity']}',
                                        style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            coperti[0]['quantity']++;
                                          });
                                        },
                                        child: Image.asset(
                                          'assets/images/plus.png',
                                          scale: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      backgroundColor: HexColor('#FF3131')),
                                  onPressed: () {
                                    setState(() {
                                      coperti[0]['quantity'] = 0;
                                    });
                                  },
                                  child: const Text('ELIMINA COPERTI'),
                                )
                              ]),
                            );
                          }),
                        );
                      });

                  //SET STATE PER AGGIORNARE LA PAGINA
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: HexColor('#FF3131'))),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/images/coperti2.png'),
                          const Text(
                            'COPERTI',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          coperti.isEmpty
                              ? '0'
                              : coperti[0]['quantity'].toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: HexColor('#FF3131'),
                              fontWeight: FontWeight.w800),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          widget.orderDetail.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 200),
                  child: const Text('Nessun prodotto per questo ordine.'),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      scrollDirection: Axis.vertical,
                      itemCount: widget.orderDetail.length,
                      itemBuilder: (BuildContext context, int index) {
                        //OPERATORE TERNARIO PER NON FAR VEDERE IL COPERTO NELLA LISTA DEI PRODOTTI
                        return widget.orderDetail[index]['product_id'] ==
                                coperto[0]['id']
                            ? Container()
                            : IgnorePointer(
                                //L'INTERO CONTAINER DIVENTA NON CLICCABILE SE QUESTE FUNZIONI RITORNANO IL COLORE DELLO STATO "PREPARATO"
                                ignoring: getProductStateColour(index) ==
                                            "#2F2DCF" &&
                                        getProductName(
                                                widget.orderDetail[index]) !=
                                            'Coperti'
                                    ? true
                                    : false,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  // margin: const EdgeInsets.only(top: 100, bottom: 150),
                                  margin: const EdgeInsets.only(bottom: 35),
                                  width: MediaQuery.of(context).size.width - 40,
                                  height: widget.orderDetail[index]
                                              ['custom_product'] !=
                                          null
                                      ? 350
                                      : 340,
                                  child: Column(
                                    children: [
                                      widget.orderDetail[index]
                                                  ['custom_product'] !=
                                              null
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              child: Tooltip(
                                                showDuration:
                                                    const Duration(seconds: 5),
                                                margin: const EdgeInsets.only(
                                                    right: 50, left: 50),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                triggerMode:
                                                    TooltipTriggerMode.tap,
                                                message:
                                                    '${getCustomProduct(widget.orderDetail[index])}',
                                                child: const Icon(Icons.info),
                                              ),
                                            )
                                          : Container(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Qtà ${widget.orderDetail[index]['quantity']}',
                                                style: TextStyle(
                                                    color: HexColor('#A1C2C5'),
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '€${widget.orderDetail[index]['price']}',
                                                style: TextStyle(
                                                    color: HexColor('#43ABFB'),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: 70,
                                            height: 70,
                                            child: getProductImage(widget
                                                        .orderDetail[index]) ==
                                                    null
                                                ? Image.asset(
                                                    'assets/images/logo.png',
                                                    scale: 2,
                                                  )
                                                : Image.network(
                                                    'https://meari.aquaconsulting.it/img/product/${getProductImage(widget.orderDetail[index])}',
                                                  ),
                                          ),
                                          Column(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                      'assets/images/clock.png'),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    '${getProductsMinutes(widget.orderDetail[index]) ?? '0'} min.',
                                                    style: TextStyle(
                                                        color:
                                                            HexColor('#43ABFB'),
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        //SE IL PRODOTTO E' CUSTOM AL CLICK DEL NOME PORTA ALLA PAGINA DI MODIFICA
                                        onTap:
                                            widget.orderDetail[index]
                                                        ['custom_product'] ==
                                                    null
                                                ? null
                                                : () async {
                                                    List
                                                        filteredCustomProducts =
                                                        [];
                                                    //PRENDI I PRODOTTI CON HIDDEN A 0
                                                    List nonHiddenProducts =
                                                        products
                                                            .where((element) =>
                                                                element[
                                                                    'hidden'] ==
                                                                0)
                                                            .toList();

                                                    //PRENDI I PRODOTTI CON LA STESSA CATEGORIA DI QUELLO CLICCATO
                                                    for (var element
                                                        in nonHiddenProducts) {
                                                      for (var category
                                                          in element[
                                                              'category']) {
                                                        if (category['name'] ==
                                                            getProductName(widget
                                                                    .orderDetail[
                                                                index])) {
                                                          filteredCustomProducts
                                                              .add(element);
                                                        }
                                                      }
                                                    }
                                                    dynamic coperto = widget
                                                        .orderDetail
                                                        .where((element) =>
                                                            element[
                                                                'product_id'] ==
                                                            1)
                                                        .toList();

                                                    //E PASSALI ALLA PAGINA DI MODIFICA
                                                    final result =
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UpdateCustomProduct(
                                                                          orderDetail:
                                                                              widget.orderDetail[index],
                                                                          coperti:
                                                                              coperto[0]['quantity'],
                                                                          order:
                                                                              widget.order,
                                                                          category: categories
                                                                              .where((element) => element['name'] == getProductName(widget.orderDetail[index]))
                                                                              .toList(),
                                                                          filteredProducts:
                                                                              filteredCustomProducts,
                                                                        )));

                                                    // REFRESH CON NAVIGATOR.POP
                                                    if (result != null) {
                                                      refreshData();
                                                    }
                                                  },
                                        child: Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 36),
                                            child: Wrap(
                                              children: [
                                                Text(
                                                  '${getProductName(widget.orderDetail[index])} ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20),
                                                ),
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  // child: CircleAvatar(
                                                  //   backgroundColor: HexColor(
                                                  //       getProductStateColour(
                                                  //           index)),
                                                  // ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                // IMPEDISCI CHE IL COUNTER VADA SOTTO 0 PER I COPERTI
                                                if (getProductName(widget
                                                        .orderDetail[index]) ==
                                                    'Coperti') {
                                                  widget.orderDetail[index]
                                                              ['quantity'] ==
                                                          0
                                                      ? null
                                                      : widget.orderDetail[
                                                          index]['quantity']--;
                                                  // IMPEDISCI CHE IL COUNTER VADA SOTTO 1 PER GLI ALTRI PRODOTTI
                                                } else {
                                                  widget.orderDetail[index]
                                                              ['quantity'] ==
                                                          1
                                                      ? null
                                                      : widget.orderDetail[
                                                          index]['quantity']--;
                                                }
                                              });
                                            },
                                            child: Image.asset(
                                              'assets/images/minus.png',
                                              scale: 1.2,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              '${widget.orderDetail[index]['quantity']}',
                                              style: const TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                widget.orderDetail[index]
                                                    ['quantity']++;
                                              });
                                            },
                                            child: Image.asset(
                                              'assets/images/plus.png',
                                              scale: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 12, bottom: 9),
                                        child: const Divider(
                                          thickness: 0.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 20),
                                                  backgroundColor:
                                                      HexColor('#FF3131')),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        DeleteModal(
                                                            function: () {
                                                          try {
                                                            Services.deleteOrderDetail(
                                                                    widget.orderDetail[
                                                                            index]
                                                                        ['id'])
                                                                .then((result) {
                                                              if (result) {
                                                                //SE NON CI SONO ERRORI TORNA INDIETRO
                                                                Navigator.pop(
                                                                    context);
                                                                //ELIMINA DAL DB E DALL'ARRAY DELL'APP QUESTO PRODOTTO
                                                                widget
                                                                    .orderDetail
                                                                    .removeAt(
                                                                        index);
                                                                setState(() {});
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  content: Text(
                                                                      'Prodotto eliminato.'),
                                                                ));
                                                              } else {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                              title: const Text('Qualcosa è andato storto.'),
                                                                              content: const Text('Controlla la tua connessione e riprova.'),
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
                                                          } catch (e) {
                                                            e;
                                                          }
                                                        }));
                                              },
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'ELIMINA PRODOTTO',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Image.asset(
                                                        'assets/images/cestino.png'),
                                                  )
                                                ],
                                              )),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  side: const BorderSide(
                                                      width: 1.4,
                                                      color: Colors.grey),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 20),
                                                  backgroundColor:
                                                      HexColor('#EBEBEB')),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  'INSERISCI NOTE PRODOTTO.'),
                                                              content:
                                                                  TextFormField(
                                                                initialValue:
                                                                    widget.orderDetail[
                                                                            index]
                                                                        [
                                                                        'note'],
                                                                onChanged:
                                                                    (value) {
                                                                  //ASSEGNA IL VALORE DEL TEXT FIELD ALLE NOTE DEL PRODOTTO
                                                                  widget.orderDetail[
                                                                          index]
                                                                      [
                                                                      'note'] = value;
                                                                },
                                                                maxLines: 10,
                                                              ),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    TextButton.icon(
                                                                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), backgroundColor: Colors.green.shade400),
                                                                        onPressed: () {
                                                                          //SE L'UTENTE CLICCA CONFERMA LE NOTE SARANNO UGUALI AL VALORE DEL TEXTFIELD
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: Image.asset(
                                                                          'assets/images/pen3.png',
                                                                        ),
                                                                        label: const Text(
                                                                          'CONFERMA',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                    TextButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            padding: const EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                    10,
                                                                                vertical:
                                                                                    10),
                                                                            backgroundColor: Colors
                                                                                .red),
                                                                        onPressed:
                                                                            () {
                                                                          //SE L'UTENTE CLICCA CANCELLA LE NOTE SARANNO VUOTE
                                                                          widget.orderDetail[index]['note'] =
                                                                              '';
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'CANCELLA',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ))
                                                                  ],
                                                                )
                                                              ],
                                                            ));
                                              },
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'NOTE',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Image.asset(
                                                      'assets/images/pen.png',
                                                      scale: 7,
                                                    ),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      }),
                ),
        ],
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateDetail(
                              userID: userID!,
                              order: widget.order,
                              orderStateID: defaultOrderState!,
                              products: products,
                              categories: categories,
                              coperti:
                                  coperti.isEmpty ? 0 : coperti[0]['quantity'],
                              orderDetail: widget.orderDetail)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: HexColor('#4BC59E'),
                  ),
                  width: 100,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'AGGIUNGI',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'PRODOTTO',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateDetail(
                              userID: userID!,
                              order: widget.order,
                              orderStateID: defaultOrderState!,
                              products: products,
                              categories: categories,
                              coperti:
                                  coperti.isEmpty ? 0 : coperti[0]['quantity'],
                              orderDetail: widget.orderDetail)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: HexColor('#438C71'),
                  ),
                  width: 100,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'AGGIUNGI',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'CATEGORIA',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // PRENDI I COPERTI DI QUESTO ORDINE
                  List copertiObject = widget.orderDetail
                      .where((element) => element['product_id'] == 1)
                      .toList();
                  int coperti;
                  copertiObject.isEmpty
                      ? coperti = 0
                      : coperti = copertiObject[0]['quantity'];

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmOrder(
                                coperti: coperti,
                                orderDetail: widget.orderDetail,
                                order: widget.order,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  width: 100,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'COMPLETA',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'COMANDA',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
