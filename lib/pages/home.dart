import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/api.dart';
import 'package:meari/api/data.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/create.dart';
import 'package:meari/pages/login.dart';
import 'package:meari/pages/orders/index.dart';
import 'package:meari/pages/orders/update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.userID});
  int userID;
  @override
  State<Home> createState() => _HomeState();
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

class _HomeState extends State<Home> {
  SharedPreferences? preferences;
  getUserData() async {
    setState(() {
      loading = true;
    });
    preferences = await SharedPreferences.getInstance();
  }

  void logout() {
    preferences!.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  String errorMessage = '';
  bool apiHasError = false;
  //funzione per chiamata api
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
  loadData() async {
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
      apiHasError = true;
      errorMessage = 'Tempo scaduto, riprovare';
    } on SocketException catch (_) {
      apiHasError = true;
      errorMessage = 'Errore, riprova';
    } on FormatException catch (_) {
      apiHasError = true;
      errorMessage =
          'Rifiuto persistente del server di destinazione, riprovare.';
    } catch (_) {
      apiHasError = true;
      errorMessage = 'Errore, riprova';
    }
    setState(() {
      loading = false;
    });
  }

  // _sendMessage() {
  //   List z = ['true', 'false'];
  //   for (var element in z) {
  //     _channel.sink.add(element);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getUserData();
    loadData();
    userID = widget.userID;
    idCustomCocktail = [];
    seeLogout = true;
  }

  // final _channel = WebSocketChannel.connect(
  //   Uri.parse('wss://echo.websocket.events'),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F3F3'),
      appBar: CustomAppBar(
        action: () {
          logout();
        },
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
              color: HexColor('#002115'),
            ))
          : Container(
              //se la chiamata http è andata in crash allora si vedrà il messaggio d'errore, altrimenti la listView-
              child: apiHasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            errorMessage,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width - 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                //USANDO LA STESSA PAGINA DI CONFERMA PER UPDATE E STORE QUESTA VARIABILE SERVER PER STABILIRE LA ROTTA DA USARE
                                confirmUpdate = false;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateOrderPage(
                                            userID: widget.userID,
                                            userName: userName)));
                                //IL TASTO LOGOUT E' DISPONIBILE SOLO ALLA PAGINA HOME
                                seeLogout = false;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: HexColor('#727270'),
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 22, bottom: 28),
                                      child: Image.asset(
                                        'assets/images/pen.png',
                                        scale: 2,
                                      ),
                                    ),
                                    const Text(
                                      'CREA COMANDA',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                //USANDO LA STESSA PAGINA DI CONFERMA PER UPDATE E STORE QUESTA VARIABILE SERVER PER STABILIRE LA ROTTA DA USARE
                                confirmUpdate = true;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderList(
                                              order: orders
                                                  //PASSA SOLO ORDINI APERTI
                                                  .where((element) =>
                                                      element['order_state']
                                                          ['state_colour'] !=
                                                      '#4BC59E')
                                                  .toList(),
                                            )));
                                //IL TASTO LOGOUT E' DISPONIBILE SOLO ALLA PAGINA HOME
                                seeLogout = false;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: HexColor('#67CDFD'),
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 15, bottom: 22),
                                      child: Image.asset(
                                        'assets/images/paper.png',
                                        scale: 2,
                                      ),
                                    ),
                                    const Text(
                                      'ELENCO COMANDE',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // StreamBuilder(
                            //   stream: _channel.stream,
                            //   builder: (context, snapshot) {
                            //     return Text(
                            //         snapshot.hasData ? '${snapshot.data}' : '');
                            //   },
                            // )
                          ],
                        ),
                      ),
                    )),
    );
  }
}
