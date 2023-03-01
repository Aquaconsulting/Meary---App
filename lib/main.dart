import 'package:flutter/material.dart';
import 'package:meari/pages/home.dart';
import 'package:meari/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
              //se c'è qualche errore torna indietro
            } else if (snapshot.hasError) {
              return const Text('Qualcosa è andato storto, riprova.');
              //se ci sono dei dati esistenti dell'utente prendi il token
            } else if (snapshot.hasData) {
              final token = snapshot.data!.getString('token');
              //se il token esiste allora vai alla home
              if (token != null) {
                return const Home();
                //altrimenti alla pagina di login
              } else {
                return const LoginPage();
              }
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                icon: Icon(Icons.abc))
          ],
        ),
        body:
            Container() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
