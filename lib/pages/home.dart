import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/api.dart';
import 'package:meari/api/data.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/create.dart';
import 'package:meari/pages/login.dart';
import 'package:meari/pages/orders/update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  Home({super.key, required this.userID});
  int userID;
  @override
  State<Home> createState() => _HomeState();
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
    String token = await API().getToken();
    var url = 'http://10.0.2.2:8000/api/apiData';
    var response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    await Future.delayed(const Duration(seconds: 1));
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
      products = homePageData['products'];
      categories = homePageData['categories'];
      orderDetails = homePageData['order_details'];
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text('Logo'),
        title: const Text('Home'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.logout),
            onSelected: (value) {
              logout();
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                )
              ];
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              //se la chiamata http è andata in crash allora si vedrà il messaggio d'errore, altrimenti la listView-
              child: apiHasError
                  ? Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.all(15),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(8),
                          itemCount: orders.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: 20,
                              child: InkWell(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateOrderPage(
                                                  currentOrder: orders[index],
                                                  orderDetail: orderDetails
                                                      .where((element) =>
                                                          element['order_id'] ==
                                                          orders[index]['id'])
                                                      .toList(),
                                                  userID: widget.userID,
                                                )));
                                  },
                                  title: Text(orders[index]['id'].toString()),
                                  subtitle:
                                      Text('note: ${orders[index]['note']}'),
                                  trailing: Text(orders[index]['order_state']
                                      ['current_state']),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            );
                          })),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // SE CI SONO ERRORI NON FAR CLICCARE IL BOTTONE
          if (!loading && !apiHasError) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateOrderPage(
                          userID: widget.userID,
                          tables: homePageData['tables'],
                          products: products,
                          categories: categories,
                        )));
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
