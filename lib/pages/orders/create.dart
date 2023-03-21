import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/api/data.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/pages/coperti.dart';
import 'package:meari/pages/orders/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrderPage extends StatefulWidget {
  CreateOrderPage(
      {super.key,
      required this.userName,
      required this.userID,
      required this.tables,
      required this.products,
      required this.categories});
  int userID;
  List tables = [];
  List products = [];
  List categories = [];
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tables = widget.tables;
  }

  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  Object currentItem = {};
  TextEditingController noteController = TextEditingController();
  List tables = [];
  int? orderID;
  addOrder() {
    try {
      Services.addOrder(widget.userID, value!, 'fix this', DateTime.now(), 1)
          .then((result) {
        if (result != false) {
          //SE LA L'API RITORNA L'OGGETTO PRENDO ID DELL'ORDINE APPENA CREATO E LO PASSO ALLA PAGINA SUCCESSIVA
          orderID = result['id'];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddPlace(
                        tableID: value!,
                        userName: widget.userName,
                        userID: widget.userID,
                        orderID: orderID!,
                        orderStateID: 1,
                        products: widget.products,
                        categories: widget.categories,
                      )));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ordine creato con successo'),
          ));
        } else {
          // SE INVECE RITORNA FALSE MOSTRA QUESTO
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

  int? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: Column(
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
                    Text(DateTime.now().toString())
                  ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              color: HexColor('#F4F3F3'),
              child: Column(
                children: const [
                  Text(
                    'ASSEGNA TAVOLO',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            ),
            Wrap(
              children: List.generate(
                  widget.tables.length,
                  (index) => InkWell(
                        onTap: () {
                          value = widget.tables[index]['id'];
                          addOrder();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor('#4BC59E'),
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          height: 110,
                          width: 110,
                          child: Center(
                            child: Text(
                              widget.tables[index]['id'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ),
                        ),
                      )),
            )
          ],
        ));
  }
}
