import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/components/customDeleteModal.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/chooseCategory.dart';
import 'package:meari/pages/orders/confirmOrder.dart';
import 'package:meari/pages/orders/filterProducts.dart';
import 'package:meari/pages/orders/updateCustomProduct.dart';

class ConfirmProduct extends StatefulWidget {
  ConfirmProduct(
      {super.key,
      required this.order,
      required this.userName,
      required this.coperti,
      required this.orderDetail,
      required this.filteredProducts});
  String userName;
  dynamic order;

  int coperti;
  List orderDetail;
  List filteredProducts;
  @override
  State<ConfirmProduct> createState() => _ConfirmProductState();
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

// class OrderDetail {
//   int order_id;
//   int order_state_id;
//   double price;
//   int quantity;
//   int product_id;
//   OrderDetail(this.order_id, this.order_state_id, this.price, this.quantity,
//       this.product_id);

//   @override
//   String toString() {
//     return '{order_id: $order_id, order_state_id: $order_state_id, price: $price, quantity: $quantity, product_id: $product_id}';
//   }
// }

class _ConfirmProductState extends State<ConfirmProduct> {
  int counter = 1;

  bool value = false;
  void refreshData() {
    setState(() {
      value = true;
    });
  }

  getProductName(orderDetail) {
    for (var element in products) {
      if (element['id'] == orderDetail['product_id']) {
        if (orderDetail['custom_product'] != null &&
            element['category'] != null) {
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

  getProductsMinutes(orderDetail) {
    for (var element in products) {
      if (element['id'] == orderDetail['product_id']) {
        return element['tempo_preparazione'];
      }
    }
  }

  List customProducts = [];
  getCustomProduct(orderDetail) {
    customProducts = [];
    if (orderDetail['custom_product'] is List == true) {
      for (var element in products) {
        for (var element2 in orderDetail['custom_product']) {
          if (element2 == element['id']) {
            customProducts.add(element['name']);
          }
        }
      }
    } else {
      var list = jsonDecode(orderDetail['custom_product']);
      for (var element in products) {
        for (var element2 in list) {
          if (element2 == element['id']) {
            customProducts.add(element['name']);
          }
        }
      }
    }

    return customProducts;
  }

  getProductStateName(int index) {
    for (var element in product_states) {
      if (element['id'] == widget.orderDetail[index]['order_state_id']) {
        return '(${element['current_state']})';
      }
    }
  }

  getProductStateColour(int index) {
    for (var element in product_states) {
      if (element['id'] == widget.orderDetail[index]['order_state_id']) {
        return element['state_colour'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: CustomAppBar(),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.userName,
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
                children: [
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor('#43ABFB')),
                  onPressed: () async {
                    String refresh = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => CustomModal(
                              orderID: widget.order['id'],
                            ));
                    refresh == 'refresh' ? refreshData() : null;
                  },
                  child: const Text('CAMBIA TAVOLO')),
              InkWell(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: null,
                          content: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: Column(children: [
                                Text(
                                  "COPERTI: ${widget.coperti}",
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
                                            widget.coperti--;
                                          });
                                        },
                                        child: Image.asset(
                                          'assets/images/minus.png',
                                          scale: 1.2,
                                        ),
                                      ),
                                      Text(
                                        '${widget.coperti}',
                                        style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            widget.coperti++;
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
                                      widget.coperti = 0;
                                    });
                                  },
                                  child: Text('ELIMINA COPERTI'),
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
                          '${widget.coperti}',
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
          SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: ListView.builder(
                padding: EdgeInsets.all(20),
                scrollDirection: Axis.vertical,
                itemCount: widget.orderDetail.length,
                itemBuilder: (BuildContext context, int index) {
                  //OPERATORE TERNARIO PER NON FAR VEDERE IL COPERTO NELLA LISTA DEI PRODOTTI
                  return widget.orderDetail[index]['product_id'] ==
                          coperto[0]['id']
                      ? Container()
                      : IgnorePointer(
                          //L'INTERO CONTAINER DIVENTA NON CLICCABILE SE QUESTE FUNZIONI RITORNANO IL COLORE DELLO STATO "PREPARATO"
                          ignoring: getProductStateColour(index) == "#2F2DCF" &&
                                  getProductName(widget.orderDetail[index]) !=
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
                                widget.orderDetail[index]['custom_product'] !=
                                        null
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        child: Tooltip(
                                          showDuration:
                                              const Duration(seconds: 5),
                                          margin: const EdgeInsets.only(
                                              right: 50, left: 50),
                                          padding: const EdgeInsets.all(10),
                                          triggerMode: TooltipTriggerMode.tap,
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
                                      child: getProductImage(
                                                  widget.orderDetail[index]) ==
                                              null
                                          ? Image.asset(
                                              'assets/images/logo.png')
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
                                              '${getProductsMinutes(widget.orderDetail[index]) ?? '0'} minuti',
                                              style: TextStyle(
                                                  color: HexColor('#43ABFB'),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        // Container(
                                        //   margin: EdgeInsets.only(top: 6),
                                        //   width: 40,
                                        //   height: 20,
                                        //   color: HexColor('#43ABFB'),
                                        //   child: const Center(
                                        //     child: Text(
                                        //       'BAR',
                                        //       style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontWeight: FontWeight.w600),
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 36),
                                    child: InkWell(
                                      //SE IL PRODOTTO E' CUSTOM AL CLICK DEL NOME PORTA ALLA PAGINA DI MODIFICA
                                      onTap: widget.orderDetail[index]
                                                  ['custom_product'] ==
                                              null
                                          ? null
                                          : () async {
                                              List filteredCustomProducts = [];
                                              //PRENDI I PRODOTTI CON HIDDEN A 0
                                              List nonHiddenProducts = products
                                                  .where((element) =>
                                                      element['hidden'] == 0)
                                                  .toList();

                                              //PRENDI I PRODOTTI CON LA STESSA CATEGORIA DI QUELLO CLICCATO
                                              for (var element
                                                  in nonHiddenProducts) {
                                                for (var category
                                                    in element['category']) {
                                                  if (category['name'] ==
                                                      getProductName(
                                                          widget.orderDetail[
                                                              index])) {
                                                    filteredCustomProducts
                                                        .add(element);
                                                  }
                                                }
                                              }

                                              //E PASSALI ALLA PAGINA DI MODIFICA
                                              final result =
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              UpdateCustomProduct(
                                                                orderDetail:
                                                                    widget.orderDetail[
                                                                        index],
                                                                coperti: widget
                                                                    .coperti,
                                                                order: widget
                                                                    .order,
                                                                category: categories
                                                                    .where((element) =>
                                                                        element[
                                                                            'name'] ==
                                                                        getProductName(
                                                                            widget.orderDetail[index]))
                                                                    .toList(),
                                                                filteredProducts:
                                                                    filteredCustomProducts,
                                                              )));

                                              //REFRESH CON NAVIGATOR.POP
                                              if (result != null) {
                                                refreshData();
                                              }
                                            },
                                      child: Text(
                                        '${getProductName(widget.orderDetail[index])} '
                                        '${getProductStateName(index) ?? ''}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          // IMPEDISCI CHE IL COUNTER VADA SOTTO 0 PER I COPERTI
                                          if (getProductName(
                                                  widget.orderDetail[index]) ==
                                              'Coperti') {
                                            widget.orderDetail[index]
                                                        ['quantity'] ==
                                                    0
                                                ? null
                                                : widget.orderDetail[index]
                                                    ['quantity']--;
                                            // IMPEDISCI CHE IL COUNTER VADA SOTTO 1 PER GLI ALTRI PRODOTTI
                                          } else {
                                            widget.orderDetail[index]
                                                        ['quantity'] ==
                                                    1
                                                ? null
                                                : widget.orderDetail[index]
                                                    ['quantity']--;
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
                                  margin:
                                      const EdgeInsets.only(top: 12, bottom: 9),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 20),
                                            backgroundColor:
                                                HexColor('#FF3131')),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DeleteModal(function: () {
                                                    setState(() {
                                                      widget.orderDetail
                                                          .removeAt(index);
                                                    });
                                                    Navigator.pop(context);
                                                  }));
                                        },
                                        child: Row(
                                          children: [
                                            const Text(
                                              'ELIMINA PRODOTTO',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Image.asset(
                                                  'assets/images/cestino.png'),
                                            )
                                          ],
                                        )),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            side: const BorderSide(
                                                width: 1.4, color: Colors.grey),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 20),
                                            backgroundColor:
                                                HexColor('#EBEBEB')),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                        'INSERISCI NOTE PRODOTTO.'),
                                                    content: TextFormField(
                                                      initialValue:
                                                          widget.orderDetail[
                                                              index]['note'],
                                                      onChanged: (value) {
                                                        //ASSEGNA IL VALORE DEL TEXT FIELD ALLE NOTE DEL PRODOTTO
                                                        widget.orderDetail[
                                                                index]['note'] =
                                                            value;
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
                                                              style: ElevatedButton.styleFrom(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10),
                                                                  backgroundColor:
                                                                      HexColor(
                                                                          '#CDD4D9')),
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
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                          TextButton.icon(
                                                              style: ElevatedButton.styleFrom(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                                  backgroundColor:
                                                                      HexColor(
                                                                          '#43ABFB')),
                                                              onPressed: () {
                                                                //SE L'UTENTE CLICCA CANCELLA LE NOTE SARANNO VUOTE
                                                                widget.orderDetail[
                                                                            index]
                                                                        [
                                                                        'note'] =
                                                                    'nessuna nota inserita';
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_back_sharp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              label: const Text(
                                                                'CANCELLA',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
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
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Image.asset(
                                                'assets/images/pen.png',
                                                scale: 7,
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                                // widget.orderDetail[index]['custom_product'] != null
                                //     ?
                                //     // Wrap(
                                //     //     children: List.generate(
                                //     //         getCustomProduct(widget.orderDetail[index])
                                //     //             .length,
                                //     //         (index) =>
                                //     //             Text('• ${customProducts[index]} ')),
                                //     //   )
                                //     Container(
                                //         margin: const EdgeInsets.only(top: 16),
                                //         child: ElevatedButton(
                                //             style: ElevatedButton.styleFrom(
                                //                 minimumSize: const Size.fromHeight(50),
                                //                 backgroundColor: HexColor('#43ABFB'),
                                //                 padding: const EdgeInsets.symmetric(
                                //                     horizontal: 40, vertical: 20)),
                                //             onPressed: () {},
                                //             child:
                                //                 const Text('MODIFICA PRODOTTO CUSTOM')),
                                //       )
                                //     : Container(),
                              ],
                            ),
                          ),
                        );
                }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                idCustomCocktail = [];

                Navigator.pop(context, 'refresh');
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
                            orderDetail: widget.orderDetail,
                            userID: userID!,
                            order: widget.order,
                            orderStateID: defaultOrderState!,
                            products: products,
                            categories: categories,
                            coperti: widget.coperti)));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmOrder(
                              coperti: widget.coperti,
                              order: widget.order,
                              orderDetail: widget.orderDetail,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor('#98B8BA'),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
