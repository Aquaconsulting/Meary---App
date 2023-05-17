import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';

class UpdateCustomProduct extends StatefulWidget {
  UpdateCustomProduct(
      {super.key,
      required this.coperti,
      required this.orderDetail,
      required this.filteredProducts,
      required this.category,
      required this.order});
  List filteredProducts;
  dynamic category;
  dynamic order;
  int coperti;
  Map orderDetail;
  @override
  State<UpdateCustomProduct> createState() => _UpdateCustomProductState();
}

class CustomSwitch extends StatelessWidget {
  CustomSwitch(
      {super.key,
      required this.selected,
      required this.product,
      required this.orderDetail,
      required this.currentList,
      required this.action});
  bool selected;
  dynamic product;
  dynamic currentList;
  dynamic orderDetail;
  Function(bool) action;
  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (value) {
        action(value);
        // value
        //     ? currentList.add(product['id'])
        //     : currentList.remove(product['id']);
        if (value) {
          currentList.add(product['id']);
        } else {
          currentList.remove(product['id']);
        }
        print(currentList);
      },
      value: selected,
    );
  }
}

class _UpdateCustomProductState extends State<UpdateCustomProduct> {
  bool value = false;
  void refreshData() {
    setState(() {
      value = true;
    });
  }

  getSelectedProducts() {
    for (var element2 in widget.orderDetail['custom_product']) {
      for (var i = 0; i < widget.filteredProducts.length; i++) {
        if (widget.filteredProducts[i]['id'] == element2) {
          list.removeAt(i);
          list.insert(i, true);
        }
      }
    }
  }

  List listID = [];
  @override
  void initState() {
    super.initState();
    getSelectedProducts();
    if (widget.orderDetail['custom_product'] is String == true) {
      listID = jsonDecode(widget.orderDetail['custom_product']);
      widget.orderDetail['custom_product'] = listID;
    }
  }

  late List currentList = widget.orderDetail['custom_product'] ?? [];
  late List<bool> list =
      List.generate(widget.filteredProducts.length, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor('#F4F3F3'),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: HexColor('#43ABFB')),
            //     onPressed: () async {
            //       String refresh = await showDialog(
            //           barrierDismissible: false,
            //           context: context,
            //           builder: (context) => CustomModal(
            //                 orderID: widget.order['id'],
            //               ));
            //       refresh == 'refresh' ? refreshData() : null;
            //     },
            //     child: const Text('CAMBIA TAVOLO')),
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
            widget.category[0]['name'],
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
                      print(widget.filteredProducts[index]['id']);
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              Text(
                                widget.filteredProducts[index]['description'] ??
                                    'Nessuna descrizione',
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
                          trailing: CustomSwitch(
                            orderDetail: widget.orderDetail,
                            currentList: currentList,
                            action: (p0) {
                              setState(() {
                                list[index] = p0;
                              });
                            },
                            selected: list[index],
                            product: widget.filteredProducts[index],
                          ),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  )),
        )
      ])),
    );
  }
}
