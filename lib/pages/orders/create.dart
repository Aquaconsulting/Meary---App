import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/api/data.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';
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
      Services.addOrder(widget.userID, value!, 'fix this', DateTime.now(),
              defaultOrderState[0]['id'])
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
  // String color = '';

  // getTableColour(int index) {
  //   for (var element in orders) {
  //     if (element['table_id'] == tables[index]['id']) {
  //       color = element['order_state']['state_colour'];
  //     }
  //   }
  //   return color;
  // }

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
                    Text(today)
                  ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              color: HexColor('#F4F3F3'),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'ASSEGNA TAVOLO',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                style: TextStyle(fontWeight: FontWeight.w700),
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
                                style: TextStyle(fontWeight: FontWeight.w700),
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
                              color: HexColor('#D0EE00'),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: const Text(
                                'IN USCITA',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  children: List.generate(
                      widget.tables.length,
                      (index) => InkWell(
                            onTap: () {
                              value = widget.tables[index]['id'];
                              //SE IL TAVOLO E' LIBERO PERMETTI DI CLICCARE
                              addOrder();
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
        ));
  }
}
