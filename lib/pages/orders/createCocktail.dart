import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/confirmOrder.dart';

class CreateCocktail extends StatefulWidget {
  CreateCocktail(
      {super.key,
      required this.orderDetail,
      required this.coperti,
      required this.order,
      required this.tableID});
  dynamic order;
  int tableID;
  int coperti;
  List orderDetail;

  @override
  State<CreateCocktail> createState() => _CreateCocktailState();
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

class CustomSwitch extends StatefulWidget {
  CustomSwitch({super.key, required this.product, required this.note});
  dynamic product;
  List note;
  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (value) {
        setState(() {
          selected = value;
          if (value) {
            widget.note.add(widget.product);
          } else {
            widget.note.remove(widget.product);
          }
        });
      },
      value: selected,
    );
  }
}

class _CreateCocktailState extends State<CreateCocktail> {
  List cocktailNote = [];
  String getNote() {
    String note = 'Cocktail: ';
    for (var element in cocktailNote) {
      note = '$note ${element['name']},';
    }
    return note;
  }

  List cocktailProducts =
      products.where((element) => element['cocktail_base'] == 1).toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F3F3'),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          margin: const EdgeInsets.all(20),
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
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
        Container(
          margin: EdgeInsets.symmetric(vertical: 40),
          child: Row(children: const [
            Expanded(
                child: Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: Colors.black,
            )),
            Text(
              'CREA COCKTAIL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Expanded(
                child: Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
              color: Colors.black,
            )),
          ]),
        ),
        Column(
          children: List.generate(
              cocktailProducts.length,
              (index) => InkWell(
                    onTap: () {},
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
                              Text(cocktailProducts[index]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
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
                              '€${cocktailProducts[index]['price']}',
                              style: TextStyle(
                                  color: HexColor('#43ABFB'),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          trailing: CustomSwitch(
                            note: cocktailNote,
                            product: cocktailProducts[index],
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor('#438C71'),
                ),
                // width: 100,
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'TORNA A',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'CATEGORIE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                getNote();
                var newItem = {
                  'order_id': widget.order['id'],
                  'order_state_id': defaultOrderState,
                  'price': 0,
                  'quantity': 1,
                  'product_id': 0
                };
                widget.orderDetail.add(newItem);
                print(widget.orderDetail);

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ConfirmOrder(
                //               coperti: widget.coperti,
                //               order: widget.order,
                //               orderDetail: widget.orderDetail,
                //             )));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor('#438C71'),
                ),
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'CONFERMA',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'COCKTAIL',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
