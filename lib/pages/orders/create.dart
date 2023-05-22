import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:meari/api/api.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/api/data.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/coperti.dart';
import 'package:meari/pages/orders/chooseCategory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class CreateOrderPage extends StatefulWidget {
  CreateOrderPage({
    super.key,
    required this.userName,
    required this.userID,
  });
  int userID;
  String userName;
  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
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

class _CreateOrderPageState extends State<CreateOrderPage> {
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  Object currentItem = {};
  TextEditingController noteController = TextEditingController();
  dynamic order;

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
    try {
      apiData = await fetchData();
      orders = apiData['orders'];
      tables = apiData['tables'];
      products = apiData['products'];
      destinations = apiData['destinazioni'];
      product_states = apiData['order_state_product'];
      categories = apiData['categories'];
      orderDetails = apiData['order_details'];
      defaultOrderState = apiData['default'][0];
      defaultProductState = apiData['order_state_product'][0]['id'];
      coperto = apiData['coperti'];
    } on TimeoutException catch (_) {
      errorMessage = 'Tempo scaduto, riprovare';
    } on SocketException catch (_) {
      errorMessage = 'Errore, riprova';
    } on FormatException catch (_) {
      errorMessage =
          'Rifiuto persistente del server di destinazione, riprovare.';
    } catch (_) {
      errorMessage = 'Errore, riprova';
    }
    setState(() {
      loading = false;
    });
  }

  addOrder({table}) {
    final Map<String, dynamic> cleanOrder = {
      'user_id': widget.userID,
      'table_id': table,
      'note': 'nessuna nota',
      'order_state_id': 1,
      'date': DateTime.now(),
      'updated_at': DateTime.now(),
      'created_at': DateTime.now(),
      'id': 0
    };

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddPlace(
                  table: table,
                  userName: widget.userName,
                  userID: widget.userID,
                  order: cleanOrder,
                  products: products,
                  categories: categories,
                )));

    // try {
    //   Services.addOrder(widget.userID, value!, 'nessuna nota', DateTime.now(),
    //           defaultOrderState!)
    //       .then((result) {
    //     if (result != false) {
    //       //SE LA L'API RITORNA L'OGGETTO PRENDO ID DELL'ORDINE APPENA CREATO E LO PASSO ALLA PAGINA SUCCESSIVA
    //       order = result;
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => AddPlace(
    //                     table: tables.where(
    //                         (element) => element['id'] == order['table_id']),
    //                     userName: widget.userName,
    //                     userID: widget.userID,
    //                     order: order,
    //                     products: products,
    //                     categories: categories,
    //                   )));
    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //         content: Text('Ordine creato con successo'),
    //       ));
    //     } else {
    //       // SE INVECE RITORNA FALSE MOSTRA QUESTO
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
    // } catch (e) {}
  }

  int? value;

  getTableColour(index) {
    String color = '';
    for (var element in orders) {
      if (element['table_id'] == tables[index]['id'] &&
          element['order_state']['state_colour'] != '#4BC59E') {
        color = element['order_state']['state_colour'];
        return color;
      }
    }

    // for (var element in orders) {
    //   if (element['table_id'] == tables[index]['id'] &&
    //       element['order_state']['state_colour'] != '#4BC59E') {

    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: RefreshIndicator(
          onRefresh: () async => await loadData(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox.fromSize(
              size: MediaQuery.of(context).size,
              child: Column(
                children: [
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
                          FloatingActionButton(
                            onPressed: () async {
                              await loadData();
                            },
                            child: Icon(Icons.refresh),
                            backgroundColor: Colors.blue,
                          ),
                          Text(today),
                        ]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    color: HexColor('#F4F3F3'),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'ASSEGNA TAVOLO',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 22,
                                    color: HexColor('#4BC59E'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: const Text(
                                      'LIBERO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 22,
                                    color: HexColor('#7200CC'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: const Text(
                                      'IN RITARDO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 22,
                                    color: HexColor('#FF3131'),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: const Text(
                                      'OCCUPATO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 22,
                                    color: HexColor('#D0EE00'),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: const Text(
                                      'IN USCITA',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.4)),
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 22,
                                    color: HexColor('#2F2DCF'),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: const Text(
                                      'CONSEGNATO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: List.generate(
                            tables.length,
                            (index) => InkWell(
                                  onTap: () {
                                    currentTable = tables[index]['name'];
                                    value = tables[index]['id'];
                                    // SE IL TAVOLO E' LIBERO ALLORA PERMETTI IL CLICK
                                    if (getTableColour(index) == null ||
                                        getTableColour(index) == '#4BC59E') {
                                      addOrder(table: tables[index]['id']);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ],
                                        color: HexColor(
                                            getTableColour(index) ?? '#4BC59E'),
                                        borderRadius: BorderRadius.circular(8)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    height: 110,
                                    width:
                                        MediaQuery.of(context).size.width / 3 -
                                            20,
                                    child: Center(
                                      child: Text(
                                        tables[index]['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                    ),
                                  ),
                                )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
