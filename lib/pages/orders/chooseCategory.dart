import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/filterProducts.dart';

class CreateDetail extends StatefulWidget {
  CreateDetail(
      {super.key,
      required this.userID,
      required this.order,
      required this.orderStateID,
      required this.products,
      required this.categories,
      required this.coperti,
      required this.orderDetail});
  dynamic order;
  int userID;

  int coperti;
  int orderStateID;
  List orderDetail;
  List<dynamic> products = [];
  List<dynamic> categories = [];
  @override
  State<CreateDetail> createState() => _CreateDetailState();
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

class _CreateDetailState extends State<CreateDetail> {
  TextEditingController noteController = TextEditingController();
  int coperti = 0;
  bool value = false;
  void refreshData() {
    setState(() {
      value = true;
    });
  }

  List filteredProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#F4F3F3'),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(today)
                  ]),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: const Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: const [
                    Text('COMANDA'),
                    Text(
                      'TAVOLO',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    )
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(width: 1, color: HexColor('#FF3131'))),
                  child: Text(
                    currentTable.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        color: HexColor('#FF3131'),
                        fontWeight: FontWeight.w900),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#43ABFB')),
                    onPressed: () async {
                      String refresh = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => CustomModal(
                                orderID: widget.order['id'],
                              ));
                      refresh == 'refresh' ? refreshData() : null;
                    },
                    child: const Text('CAMBIA TAVOLO')),
                InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: null,
                            content: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                child: Column(children: [
                                  Text(
                                    "COPERTI: ${widget.coperti}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              widget.coperti--;
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/images/minus.png',
                                            scale: 1.2,
                                          ),
                                        ),
                                        Text(
                                          '${widget.coperti}',
                                          style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              widget.coperti++;
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/images/plus.png',
                                            scale: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        backgroundColor: HexColor('#FF3131')),
                                    onPressed: () {
                                      setState(() {
                                        widget.coperti = 0;
                                      });
                                    },
                                    child: Text('ELIMINA COPERTI'),
                                  )
                                ]),
                              );
                            }),
                          );
                        });

                    //SET STATE PER AGGIORNARE LA PAGINA
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(width: 1, color: HexColor('#FF3131'))),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/images/coperti2.png'),
                            const Text(
                              'COPERTI',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${widget.coperti}',
                            style: TextStyle(
                                fontSize: 20,
                                color: HexColor('#FF3131'),
                                fontWeight: FontWeight.w800),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Wrap(
              children: List.generate(
                widget.categories.length,
                (index) => InkWell(
                    onTap: () {
                      filteredProducts = [];
                      List nonHiddenProducts = products
                          .where((element) => element['hidden'] == 0)
                          .toList();
                      for (var element in nonHiddenProducts) {
                        for (var category in element['category']) {
                          if (category['id'] ==
                              widget.categories[index]['id']) {
                            filteredProducts.add(element);
                          }
                        }
                      }
                      print(widget.categories[index]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowCategory(
                                  orderDetail: widget.orderDetail,
                                  coperti: widget.coperti,
                                  filteredProducts: filteredProducts,
                                  category: widget.categories[index],
                                  order: widget.order,
                                  userName: userName)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 8),
                      height: 170,
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      child: Container(
                        padding: EdgeInsets.all(26),
                        decoration: BoxDecoration(
                            color: HexColor('#CDD4D9'),
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.network(
                              'https://meari.aquaconsulting.it/img/category/${widget.categories[index]['image']}',
                              scale: 3,
                              // child: Text(widget.categories[index]['name']),
                            ),
                            Text(
                              widget.categories[index]['name'],
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            )
          ]),
        ));
  }
}
