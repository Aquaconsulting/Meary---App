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
  bool loading = true;
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
    var url = 'http://10.0.2.2:8000/api/apiData';
    var response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    await Future.delayed(const Duration(milliseconds: 200));
    loading = false;
    final Map<String, dynamic> parsed = json.decode(response.body);
    return parsed;
  }

  //funzione async per caricamento dati con try catch
  loadData() async {
    setState(() {
      loading = true;
    });
    //try catch per la chiamata http
    try {
      homePageData = await fetchData();
      orders = homePageData['orders'];
      tables = homePageData['tables'];
      products = homePageData['products'];
      categories = homePageData['categories'];
      orderDetails = homePageData['order_details'];
      defaultOrderState = homePageData['default'][0];
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

  @override
  void initState() {
    super.initState();
    getUserData();
    loadData();
    userID = widget.userID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F3F3'),
      appBar: CustomAppBar(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
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
                          ElevatedButton(
                              onPressed: () {
                                logout();
                              },
                              child: Text('LOGOUT'))
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateOrderPage(
                                            userID: widget.userID,
                                            tables: homePageData['tables'],
                                            products: products,
                                            categories: categories,
                                            userName: userName)));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderList()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: HexColor('##67CDFD'),
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
                          ],
                        ),
                      ),
                    )),
    );
  }
}
