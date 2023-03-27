import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/data.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/confirmProduct.dart';
import 'package:meari/pages/orders/chooseCategory.dart';

class ShowCategory extends StatefulWidget {
  ShowCategory(
      {super.key,
      required this.coperti,
      required this.orderID,
      required this.tableID,
      required this.userName,
      required this.filteredProducts,
      required this.category,
      required this.orderDetail});
  String userName;
  int orderID;
  List orderDetail;
  int tableID;
  int coperti;
  dynamic category;
  List filteredProducts;
  @override
  State<ShowCategory> createState() => _ShowCategoryState();
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

class _ShowCategoryState extends State<ShowCategory> {
  final OrderDetail? orderdetail = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#F4F3F3'),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
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
                              orderID: widget.orderID,
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
                        Text(
                          'COPERTI',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
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
            height: 50,
          ),
          Row(children: [
            const Expanded(
                child: Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: Colors.black,
            )),
            Text(
              widget.category['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const Expanded(
                child: Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: Colors.black,
            )),
          ]),
          Column(
            children: List.generate(
                widget.filteredProducts.length,
                (index) => InkWell(
                      onTap: () {
                        var newItem = {
                          'order_id': widget.orderID,
                          'order_state_id': defaultOrderState,
                          'price': double.parse(
                              widget.filteredProducts[index]['price']),
                          'quantity': 1,
                          'product_id': widget.filteredProducts[index]['id']
                        };
                        //CHECK SE IL PRODOTTO GIA E' PRESENTE NELL'ORDINE
                        var existingItem = widget.orderDetail.firstWhere(
                            (itemToCheck) =>
                                itemToCheck['product_id'] ==
                                newItem['product_id'],
                            orElse: () => null);
                        // SE NON ESISTE AGGIUNGI
                        if (existingItem == null) {
                          widget.orderDetail.add(newItem);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmProduct(
                                    orderDetail: widget.orderDetail,
                                    coperti: widget.coperti,
                                    orderID: widget.orderID,
                                    tableID: widget.tableID,
                                    userName: widget.userName)));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 4,
                          shadowColor: Colors.blueGrey,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            leading: Image.asset(
                              'assets/images/logo.png',
                              scale: 2.5,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.filteredProducts[index]['name'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                Text(
                                  'Breve descrizione',
                                  style: TextStyle(
                                      fontSize: 12, color: HexColor('#A1C2C5')),
                                )
                              ],
                            ),
                            subtitle: Container(
                              margin: EdgeInsets.only(top: 30),
                              child: Text(
                                '€${widget.filteredProducts[index]['price']}',
                                style: TextStyle(
                                    color: HexColor('#43ABFB'),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            trailing: Text('da aggiungere'),
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    )),
          )
        ])));
  }
}
