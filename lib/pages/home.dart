import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/api.dart';
import 'package:meari/api/data.dart';
import 'package:meari/pages/login.dart';
// import 'package:navi/api/api.dart';
// import 'package:navi/api/services.dart';
// import 'package:navi/data.dart';
// import 'package:navi/login.dart';
// import 'package:navi/table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

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
    //loading false viene richiamato nella funzione api
    // setState(() {
    //   loading = false;
    // });
  }

  void logout() {
    preferences!.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Map<dynamic, dynamic> homePage = {};
  List<dynamic> home = [];
  String errorMessage = '';
  bool apiHasError = false;
  //funzione per chiamata api
  Future<Map<dynamic, dynamic>> fetchData() async {
    String token = await API().getToken();
    var url = 'http://127.0.0.1:8000/api/apiData';
    var response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    await Future.delayed(const Duration(seconds: 1));
    loading = false;
    final Map parsed = json.decode(response.body);
    print(parsed);
    return parsed;
  }

  //funzione async per caricamento dati con try catch
  loadData() async {
    setState(() {
      loading = true;
    });
    //try catch per la chiamata http
    try {
      homePage = await fetchData();
      home = homePage.keys.toList();
    } on TimeoutException catch (_) {
      apiHasError = true;
      errorMessage = 'Tempo scaduto, riprovare';
    } on SocketException catch (_) {
      apiHasError = true;
      errorMessage = 'Qualcosa è andato storto, riprovare.';
    }

    // on FormatException catch (_) {
    //   apiHasError = true;
    //   errorMessage =
    //       'Rifiuto persistente del server di destinazione, riprovare.';
    // }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: Text('Logout'))
          ],
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                //se la chiamata http è andata in crash allora si vedrà il messaggio d'errore, altrimenti la listView-
                child: apiHasError
                    ? Center(
                        child: Text(errorMessage),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(8),
                        itemCount: home.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(children: [Text(home[index])]);
                        }),
              ));
  }
}
