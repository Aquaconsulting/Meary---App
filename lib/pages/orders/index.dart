import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/home.dart';
import 'package:meari/pages/orders/update.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
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

class _OrderListState extends State<OrderList> {
  getOrderPrice(int index) {
    double orderPrice = 0;
    for (var element in orderDetails) {
      if (element['order_id'] == orders[index]['id']) {
        dynamic counter = double.parse(element['price']) * element['quantity'];
        orderPrice = counter + orderPrice;
      }
    }
    return orderPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F3F3'),
      appBar: CustomAppBar(),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'Ancora nessun ordine.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(userName), Text(today)],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 150,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ],
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                decoration: BoxDecoration(
                                    color: HexColor('#A1C2C5'),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        topLeft: Radius.circular(8))),
                                child: Row(
                                  children: [
                                    const Text('COMANDA',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white)),
                                    const Text('  '),
                                    Text('ID-${orders[index]['id']}',
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                    InkWell(
                                      onTap: () {
                                        print(orderDetails);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateOrder(
                                                      order: orders[index],
                                                      orderDetail: orderDetails
                                                          .where((element) =>
                                                              element[
                                                                  'order_id'] ==
                                                              orders[index]
                                                                  ['id'])
                                                          .toList(),
                                                    )));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 12),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: 36,
                                        height: 36,
                                        child: Image.asset(
                                            'assets/images/pen4.png'),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      'Sei sicuro di voler eliminare questo ordine?'),
                                                  content: const Text(
                                                      'Questa azione è irreversibile.'),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        TextButton.icon(
                                                            style: ElevatedButton.styleFrom(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                                backgroundColor:
                                                                    HexColor(
                                                                        '#FF3131')),
                                                            onPressed: () {
                                                              try {
                                                                Services.deleteOrder(
                                                                        orders[index]
                                                                            [
                                                                            'id'])
                                                                    .then(
                                                                        (result) {
                                                                  print(result);
                                                                  if (result) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                Home(userID: userID!)));
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            const SnackBar(
                                                                      content: Text(
                                                                          'Ordine eliminato'),
                                                                    ));
                                                                  } else {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            AlertDialog(
                                                                              title: const Text('Qualcosa è andato storto.'),
                                                                              content: const Text('Controlla la tua connessione e riprova.'),
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
                                                            },
                                                            icon: Image.asset(
                                                                'assets/images/cestino.png'),
                                                            label: const Text(
                                                              'ELIMINA',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                        TextButton.icon(
                                                            style: ElevatedButton.styleFrom(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                                backgroundColor:
                                                                    HexColor(
                                                                        '#43ABFB')),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .arrow_back_sharp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: const Text(
                                                              'INDIETRO',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))
                                                      ],
                                                    )
                                                  ],
                                                ));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: 36,
                                        height: 36,
                                        child: Image.asset(
                                            'assets/images/redbin.png'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10, right: 5),
                                    child: Text('€',
                                        style: TextStyle(
                                            color: HexColor('#43ABFB'),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 25)),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        getOrderPrice(index).toString() !=
                                                'null'
                                            ? getOrderPrice(index).toString()
                                            : '0',
                                        style: TextStyle(
                                            color: HexColor('#43ABFB'),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Totale',
                                        style: TextStyle(
                                            color: HexColor('#43ABFB'),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 8),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}
