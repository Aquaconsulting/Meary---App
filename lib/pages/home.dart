import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/api.dart';
import 'package:meari/api/data.dart';
import 'package:meari/main.dart';
import 'package:meari/pages/orders/create.dart';
import 'package:meari/pages/login.dart';
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

  Map<dynamic, dynamic> homePageData = {};
  List orders = [];

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
      print(homePageData['orders'][0]['order_state']);
    } on TimeoutException catch (_) {
      apiHasError = true;
      errorMessage = 'Tempo scaduto, riprovare';
    } on SocketException catch (_) {
      apiHasError = true;
      errorMessage = 'Caricamento dei dati ';
    } on FormatException catch (_) {
      apiHasError = true;
      errorMessage =
          'Rifiuto persistente del server di destinazione, riprovare.';
    }
    setState(() {
      loading = false;
    });
  }

  // List<Order> orders = [];
  // List<TableData> tables = [];

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
        title: Text('Homeaa ${widget.userID.toString()}'),
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
                        style: const TextStyle(fontSize: 17),
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
                              child: ListTile(
                                title: Text(orders[index]['id'].toString()),
                                subtitle:
                                    Text('note: ${orders[index]['note']}'),
                                trailing: Text(orders[index]['order_state']
                                    ['current_state']),
                              ),
                            );
                          })),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: loading
            //se la chiamata sta ancora caricando non fare cliccare il bottone
            ? null
            : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateOrderPage(
                              userID: widget.userID,
                              tables: homePageData['tables'],
                            )));
              },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
