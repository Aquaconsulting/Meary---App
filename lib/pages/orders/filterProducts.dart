import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';

import 'package:meari/components/customAppBar.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';

import 'package:meari/pages/orders/confirmProduct.dart';

class ShowCategory extends StatefulWidget {
  ShowCategory(
      {super.key,
      required this.coperti,
      required this.order,
      required this.userName,
      required this.filteredProducts,
      required this.category,
      required this.orderDetail});
  String userName;
  dynamic order;
  List orderDetail;

  int coperti;
  dynamic category;
  List filteredProducts;
  @override
  State<ShowCategory> createState() => _ShowCategoryState();
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

class CustomSwitch extends StatelessWidget {
  CustomSwitch(
      {super.key,
      required this.selected,
      required this.product,
      required this.action});
  bool selected;
  dynamic product;
  Function(bool) action;
  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (value) {
        action(value);
        value
            ? idCustomCocktail.add(product['id'])
            : idCustomCocktail.remove(product['id']);
      },
      value: selected,
    );
  }
}

class _ShowCategoryState extends State<ShowCategory> {
  bool value = false;
  void refreshData() {
    setState(() {
      value = true;
    });
  }

  late List<bool> list =
      List.generate(widget.filteredProducts.length, (index) => false);

  dynamic createdCocktail;
  createCustomCocktail(request) async {
    try {
      await Services.createCustomCocktail(request).then((result) {
        if (result != null) {
          createdCocktail = result;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('cocktail creato con successo'),
          ));

          return createdCocktail;
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
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor('#F4F3F3'),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
            margin: const EdgeInsets.symmetric(horizontal: 30),
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
          const SizedBox(
            height: 50,
          ),
          Row(children: [
            const Expanded(
                child: Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: Colors.black,
            )),
            Text(
              widget.category['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const Expanded(
                child: Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: Colors.black,
            )),
          ]),
          widget.category['composed'] == 1
              ? Column(
                  children: List.generate(
                      widget.filteredProducts.length,
                      (index) => InkWell(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                elevation: 4,
                                shadowColor: Colors.blueGrey,
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  leading: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Image.network(
                                      'https://meari.aquaconsulting.it/img/product/${widget.filteredProducts[index]['image']}',
                                      scale: 2,
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.filteredProducts[index]
                                              ['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        widget.filteredProducts[index]
                                                ['description'] ??
                                            'Nessuna descrizione',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor('#A1C2C5')),
                                      )
                                    ],
                                  ),
                                  subtitle: Container(
                                    margin: EdgeInsets.only(top: 30),
                                    child: Text(
                                      '€${widget.filteredProducts[index]['price']}',
                                      style: TextStyle(
                                          color: HexColor('#43ABFB'),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  trailing: CustomSwitch(
                                    action: (p0) {
                                      setState(() {
                                        list[index] = p0;
                                      });
                                    },
                                    selected: list[index],
                                    product: widget.filteredProducts[index],
                                  ),
                                  tileColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          )),
                )
              : Column(
                  children: List.generate(
                      widget.filteredProducts.length,
                      (index) => InkWell(
                            onTap: () {
                              var newItem = {
                                'order_id': widget.order['id'],
                                'order_state_id': defaultOrderState,
                                'price': double.parse(
                                    widget.filteredProducts[index]['price']),
                                'quantity': 1,
                                'product_id': widget.filteredProducts[index]
                                    ['id']
                              };
                              //CHECK SE IL PRODOTTO GIA E' PRESENTE NELL'ORDINE
                              var existingItem = widget.orderDetail.firstWhere(
                                  (itemToCheck) =>
                                      itemToCheck['product_id'] ==
                                          newItem['product_id'] &&
                                      itemToCheck['order_state_id'] ==
                                          newItem['order_state_id'],
                                  orElse: () => null);
                              // SE NON ESISTE AGGIUNGI
                              if (existingItem == null) {
                                widget.orderDetail.add(newItem);
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConfirmProduct(
                                          filteredProducts:
                                              widget.filteredProducts,
                                          orderDetail: widget.orderDetail,
                                          coperti: widget.coperti,
                                          order: widget.order,
                                          userName: widget.userName)));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                elevation: 4,
                                shadowColor: Colors.blueGrey,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 6),
                                  leading: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Image.network(
                                      'https://meari.aquaconsulting.it/img/product/${widget.filteredProducts[index]['image']}',
                                      scale: 2,
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.filteredProducts[index]
                                              ['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        widget.filteredProducts[index]
                                                ['description'] ??
                                            'Nessuna descrizione',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor('#A1C2C5')),
                                      )
                                    ],
                                  ),
                                  subtitle: Container(
                                    margin: const EdgeInsets.only(top: 30),
                                    child: Text(
                                      '€${widget.filteredProducts[index]['price']}',
                                      style: TextStyle(
                                          color: HexColor('#43ABFB'),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  trailing: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/clock.png',
                                        scale: 1.6,
                                      ),
                                      Text(
                                        '${widget.filteredProducts[index]['tempo_preparazione']} minuti',
                                        style: TextStyle(
                                            color: HexColor('#43ABFB'),
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  tileColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          )),
                )
        ])),
        bottomNavigationBar: widget.category['composed'] == 1
            ? Container(
                margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: HexColor('#438C71'),
                        ),
                        // width: 100,
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'TORNA A',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              'CATEGORIE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (idCustomCocktail.isNotEmpty) {
                          // CREA OGGETTO DA PASSARE ALLA FUNZIONE API
                          var bar = destinations
                              .where((element) => element['name'] == 'Bar')
                              .toList();
                          var customCocktail = {
                            'name': widget.category['name'],
                            'price': widget.category['price_composed'],
                            'description': 'custom Cocktail',
                            'destination_id': bar[0]['id'],
                            'state': 1,
                            'tempo_preparazione': 5
                          };

                          await createCustomCocktail(customCocktail);

                          //CREA OGGETTO DA PASSARE ALL'ORDINE COI VALORI RITORNATI DALLA FUNZIONE
                          var newItem = {
                            'order_id': widget.order['id'],
                            'order_state_id': defaultOrderState,
                            'price': widget.category['price_composed'],
                            'quantity': 1,
                            'product_id': createdCocktail['id'],
                            'custom_product': idCustomCocktail
                          };

                          products.add(createdCocktail);
                          widget.orderDetail.add(newItem);
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfirmProduct(
                                      filteredProducts: widget.filteredProducts,
                                      order: widget.order,
                                      userName: userName,
                                      coperti: widget.coperti,
                                      orderDetail: widget.orderDetail)));
                          if (result != null) {
                            setState(() {
                              list = List.generate(
                                  widget.filteredProducts.length,
                                  (index) => false);
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: HexColor('#438C71'),
                        ),
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'CONFERMA',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                              'COCKTAIL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null);
  }
}
