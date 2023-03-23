import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/home.dart';

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({super.key});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
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

class _ConfirmOrderState extends State<ConfirmOrder> {
  double totalPrice = 0;
  getTotalPrice() {
    for (var element in details) {
      var counting = element.price * element.quantity;
      totalPrice = totalPrice + counting;
    }
    return totalPrice;
  }

  getProductName(x) {
    for (var element in products) {
      if (element['id'] == x.productID) {
        return element['name'];
      }
    }
  }

  addOrderDetail() {
    try {
      Services.addOrderDetail(details, 'tofix').then((result) {
        print(result);
        if (result) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(userID: userID!)));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Dettaglio ordine creato con successo'),
          ));
          //SVUOTA ARRAY DEI PRODOTTI
          details = [];
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
                            Navigator.pop(context);
                          }),
                          child: const Text('Chiudi'))
                    ],
                  ));
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F3F3'),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, left: 20, right: 20),
            height: 550,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: HexColor('#A1C2C5'),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('COMANDA',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 28)),
                      Text(' '),
                      Text(
                        'ID-1',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 28),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text('€',
                                style: TextStyle(
                                    color: HexColor('#43ABFB'),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25)),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getTotalPrice().toString(),
                                    style: TextStyle(
                                        color: HexColor('#43ABFB'),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    'Totale',
                                    style: TextStyle(
                                        color: HexColor('#43ABFB'),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 9),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            child: Image.asset('assets/images/clock.png'),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '11:00',
                                  style: TextStyle(
                                      color: HexColor('#43ABFB'),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                                Text(
                                  'Minuti',
                                  style: TextStyle(
                                      color: HexColor('#43ABFB'),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 9),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      width: 1, color: Colors.black)),
                            ),
                          ),
                          Image.asset('assets/images/redclock.png'),
                          Container(
                            margin: const EdgeInsets.only(left: 4, right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '20:00',
                                  style: TextStyle(
                                      color: HexColor('##FF3131'),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                                Text(
                                  'Tot attesa',
                                  style: TextStyle(
                                      color: HexColor('##FF3131'),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 9),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  color: HexColor('#F4F3F3'),
                  child: Center(
                    child: Text(
                      'Tutti i prodotti sono stati aggiunti correttamente alla comanda.',
                      style: TextStyle(
                          fontSize: 20,
                          color: HexColor('#002115'),
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                SizedBox(
                  height: 340,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), //IMPORTANTE
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: details.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Card(
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                leading: Image.asset(
                                  'assets/images/logo.png',
                                  scale: 2.5,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(getProductName(details[index]),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      'Quantità ${details[index].quantity}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: HexColor('#A1C2C5'),
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                subtitle: Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Text(
                                    '€${details[index].price}',
                                    style: TextStyle(
                                        color: HexColor('#43ABFB'),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                trailing: Text('da aggiungere'),
                                tileColor: Colors.white,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 15),
                              backgroundColor: HexColor('#43ABFB')),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: const Text(
                                  'MODIFICA COMANDA',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              Image.asset(
                                'assets/images/pen2.png',
                                scale: 1.2,
                              )
                            ],
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 15),
                              backgroundColor: HexColor('#CDD4D9')),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: const Text(
                                  'NOTE COMANDA',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              Image.asset(
                                'assets/images/pen3.png',
                                scale: 1,
                              )
                            ],
                          )),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 15),
                              backgroundColor: HexColor('#FF3131')),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text(
                                  'ELIMINA COMANDA',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              Image.asset(
                                'assets/images/cestino.png',
                                scale: 0.8,
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 15),
                              backgroundColor: HexColor('#4BC59E')),
                          onPressed: () {
                            addOrderDetail();
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: const Text(
                                  'INVIA COMANDA',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              Image.asset(
                                'assets/images/arrow.png',
                                scale: 1.2,
                              )
                            ],
                          )),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
