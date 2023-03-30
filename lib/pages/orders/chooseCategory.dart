import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/api/data.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/filterProducts.dart';
import 'package:meari/pages/home.dart';

class CreateDetail extends StatefulWidget {
  CreateDetail(
      {super.key,
      required this.tableID,
      required this.userID,
      required this.order,
      required this.orderStateID,
      required this.products,
      required this.categories,
      required this.coperti,
      required this.orderDetail});
  dynamic order;
  int userID;
  int tableID;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#F4F3F3'),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: const EdgeInsets.all(20),
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
                  children: [
                    Text('COMANDA'),
                    Text(
                      'TAVOLO',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(width: 1, color: HexColor('#FF3131'))),
                  child: Text(
                    widget.tableID.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        color: HexColor('#FF3131'),
                        fontWeight: FontWeight.w900),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#43ABFB')),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => CustomModal(
                                orderID: widget.order['id'],
                              ));
                    },
                    child: const Text('CAMBIA TAVOLO')),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: HexColor('#FF3131'))),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowCategory(
                                      orderDetail: widget.orderDetail,
                                      coperti: widget.coperti,
                                      filteredProducts: products
                                          .where((element) =>
                                              element['category_id'] ==
                                              widget.categories[index]['id'])
                                          .toList(),
                                      category: widget.categories[index],
                                      order: widget.order,
                                      tableID: widget.tableID,
                                      userName: userName)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          height: 170,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          child: Container(
                            decoration: BoxDecoration(
                                color: HexColor('#CDD4D9'),
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                              child: Text(widget.categories[index]['name']),
                            ),
                          ),
                        ),
                      )),
            )
          ]),
        ));
  }
}
