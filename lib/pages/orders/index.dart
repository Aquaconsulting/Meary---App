import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:http/http.dart' as http;
import 'package:meari/api/api.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/home.dart';
import 'package:meari/pages/orders/update.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderList extends StatefulWidget {
  OrderList({super.key, required this.order});
  dynamic order;
  @override
  State<OrderList> createState() => _OrderListState();
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

class _OrderListState extends State<OrderList> {
  Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    userName = pre.getString('name')!;
    String token = await API().getToken();
    var url = 'https://meari.aquaconsulting.it/api/apiData';
    var response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    loading = false;
    try {
      final dynamic parsed = json.decode(utf8.decode(response.bodyBytes));
      return parsed;
    } catch (e) {
      return {'e': e};
    }
  }

  //funzione async per caricamento dati con try catch
  Future<void> loadData() async {
    setState(() {
      loading = true;
    });
    //try catch per la chiamata http
    apiData = await fetchData();
    orders = apiData['orders']
        .where((element) => element['order_state']['state_colour'] != '#4BC59E')
        .toList();
    tables = apiData['tables'];
    products = apiData['products'];
    destinations = apiData['destinazioni'];
    product_states = apiData['order_state_product'];
    categories = apiData['categories'];
    orderDetails = apiData['order_details'];
    defaultOrderState = apiData['default'][0];
    defaultProductState = apiData['order_state_product'][0]['id'];
    coperto = apiData['coperti'];
    setState(() {
      loading = false;
    });
  }

  getOrderPrice(int index) {
    double orderPrice = 0;
    for (var element in orderDetails) {
      if (element['order_id'] == orders[index]['id']) {
        dynamic counter = double.parse(element['price']) * element['quantity'];
        orderPrice = counter + orderPrice;
      }
    }
    return orderPrice;
  }

  List destinazioni = [];
  List destinazioniFinali = [];
  getDestination(int index) {
    destinazioni = [];
    destinazioniFinali = [];
    for (var element in orderDetails) {
      if (element['order_id'] == orders[index]['id']) {
        for (var product in products) {
          if (element['product_id'] == product['id']) {
            for (var destination in destinations) {
              if (product['destination_id'] == destination['id']) {
                destinazioni.add(destination['name']);
                destinazioniFinali = destinazioni.toSet().toList();
              }
            }
          }
        }
      }
    }
    return destinazioniFinali;
  }

  getOrderMinutes(int index) {
    int counter = 0;
    for (var element in orderDetails) {
      if (element['order_id'] == orders[index]['id']) {
        for (var product in products) {
          if (element['product_id'] == product['id']) {
            //controllo per i prodotti che hanno null come tempo di preparazione
            product['tempo_preparazione'] != null
                ? counter = product['tempo_preparazione'] + counter
                : null;
          }
        }
      }
    }
    return counter;
  }

  changeState(orderId) {
    try {
      Services.changeState(orderId).then((result) {
        if (result) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(userID: userID!)));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Stato modificato in pagamento'),
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
                            Navigator.pop(context, '');
                          }),
                          child: const Text('Chiudi'))
                    ],
                  ));
        }
      });
    } catch (e) {}
  }

  dynamic orders;
  @override
  void initState() {
    super.initState();
    destinazioni = [];
    destinazioniFinali = [];
    orders = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F3F3'),
      appBar: CustomAppBar(),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'Ancora nessun ordine.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(userName),
                      FloatingActionButton(
                        onPressed: () async {
                          await loadData();
                        },
                        child: Icon(Icons.refresh),
                        backgroundColor: Colors.blue,
                      ),
                      Text(today)
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => await loadData(),
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              currentTable = orders[index]['table']['name'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateOrder(
                                            order: orders[index],
                                            orderDetail: orderDetails
                                                .where((element) =>
                                                    element['order_id'] ==
                                                    orders[index]['id'])
                                                .toList(),
                                          )));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 170,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 30),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 20),
                                    decoration: BoxDecoration(
                                        color: HexColor(orders[index]
                                            ['order_state']['state_colour']),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            topLeft: Radius.circular(8))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text('COMANDA',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white)),
                                                  const Text('  '),
                                                  Text(
                                                      'ID-${orders[index]['id']}',
                                                      style: const TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white)),
                                                ],
                                              ),
                                              Text(
                                                  'Tavolo - ${orders[index]['table']['name']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white))
                                            ],
                                          ),
                                        ),
                                        //Icona
                                        // InkWell(
                                        //   onTap: () {
                                        //     currentTable =
                                        //         orders[index]['table']['name'];
                                        //     Navigator.push(
                                        //         context,
                                        //         MaterialPageRoute(
                                        //             builder: (context) =>
                                        //                 UpdateOrder(
                                        //                   order: orders[index],
                                        //                   orderDetail: orderDetails
                                        //                       .where((element) =>
                                        //                           element[
                                        //                               'order_id'] ==
                                        //                           orders[index]
                                        //                               ['id'])
                                        //                       .toList(),
                                        //                 )));
                                        //   },
                                        //   child: Container(
                                        //     // margin: const EdgeInsets.only(left: 40),
                                        //     decoration: BoxDecoration(
                                        //         color: Colors.white,
                                        //         borderRadius:
                                        //             BorderRadius.circular(5)),
                                        //     width: 42,
                                        //     height: 42,
                                        //     child: Image.asset(
                                        //         'assets/images/pen4.png'),
                                        //   ),
                                        // ),
                                        InkWell(
                                          onTap: () {
                                            //SE L'ORDINE E' GIA' IN PAGAMENTO ALLORA MOSTRA IL MESSAGGIO
                                            if (orders[index]['order_state']
                                                    ['state_colour'] ==
                                                '#D0EE00') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                duration: Duration(
                                                    milliseconds: 1500),
                                                content: Text(
                                                    'Ordine già in pagamento.'),
                                              ));
                                            } else {
                                              //ALTRIMENTI LA MODALE CON IL BOTTONE PER CAMBIARE STATO
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading: Icon(
                                                            Icons
                                                                .payments_outlined,
                                                            color: HexColor(
                                                                '#43ABFB'),
                                                          ),
                                                          title: const Text(
                                                            'CAMBIA STATO IN PAGAMENTO',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          onTap: () {
                                                            changeState(
                                                                orders[index]
                                                                    ['id']);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            width: 42,
                                            height: 42,
                                            child: Icon(
                                              Icons.payments_outlined,
                                              color: HexColor('#43ABFB'),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: Text('€',
                                                style: TextStyle(
                                                    color: HexColor('#43ABFB'),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25)),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                getOrderPrice(index)
                                                            .toString() !=
                                                        'null'
                                                    ? getOrderPrice(index)
                                                        .toStringAsFixed(2)
                                                    : '0',
                                                style: TextStyle(
                                                    color: HexColor('#43ABFB'),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                'Totale',
                                                style: TextStyle(
                                                    color: HexColor('#43ABFB'),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: List.generate(
                                            getDestination(index).length,
                                            (index) => Container(
                                                  decoration: BoxDecoration(
                                                      color: destinazioniFinali[
                                                                  index] ==
                                                              'Cucina'
                                                          ? HexColor('#438C71')
                                                          : HexColor('#43ABFB'),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 8),
                                                  child: Text(
                                                    destinazioniFinali[index]
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                )),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        child: Row(
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                child: Image.asset(
                                                    'assets/images/clock.png')),
                                            Column(
                                              children: [
                                                Text(
                                                  getOrderMinutes(index)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color:
                                                          HexColor('#43ABFB'),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  'min.',
                                                  style: TextStyle(
                                                      color:
                                                          HexColor('#43ABFB'),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            decoration: BoxDecoration(border: Border.all(width: 0.4)),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 22,
                  color: HexColor('#D0EE00'),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: const Text(
                    'IN PAGAMENTO',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 0.4)),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 22,
                  color: HexColor('#2F2DCF'),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: const Text(
                    'PRONTA',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 0.4)),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 22,
                  color: HexColor('#FF3131'),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: const Text(
                    'APERTA',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 0.4)),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 22,
                  color: HexColor('#7200CC'),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: const Text(
                    'IN RITARDO',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
