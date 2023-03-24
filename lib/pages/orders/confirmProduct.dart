import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/chooseCategory.dart';
import 'package:meari/pages/orders/confirmOrder.dart';

class ConfirmProduct extends StatefulWidget {
  ConfirmProduct(
      {super.key,
      required this.orderID,
      required this.tableID,
      required this.userName,
      required this.coperti,
      required this.orderDetail});
  String userName;
  int orderID;
  int tableID;
  int coperti;
  List orderDetail;
  @override
  State<ConfirmProduct> createState() => _ConfirmProductState();
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

class OrderDetail {
  int order_id;
  int order_state_id;
  double price;
  int quantity;
  int product_id;
  OrderDetail(this.order_id, this.order_state_id, this.price, this.quantity,
      this.product_id);

  @override
  String toString() {
    return '{order_id: $order_id, order_state_id: $order_state_id, price: $price, quantity: $quantity, product_id: $product_id}';
  }
}

class _ConfirmProductState extends State<ConfirmProduct> {
  int counter = 1;

  getProductName(x) {
    for (var element in products) {
      if (element['id'] == x.product_id) {
        return element['name'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: CustomAppBar(),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 8),
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
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
          SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: ListView.builder(
                padding: EdgeInsets.all(20),
                scrollDirection: Axis.vertical,
                itemCount: widget.orderDetail.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    // margin: const EdgeInsets.only(top: 100, bottom: 150),
                    margin: const EdgeInsets.only(bottom: 35),
                    width: MediaQuery.of(context).size.width - 40,
                    height: 285,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Qtà ${widget.orderDetail[index].quantity}',
                                  style: TextStyle(
                                      color: HexColor('#A1C2C5'),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '€${widget.orderDetail[index].price}',
                                  style: TextStyle(
                                      color: HexColor('#43ABFB'),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Container(
                              child: Image.asset(
                                'assets/images/logo.png',
                                scale: 2,
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset('assets/images/clock.png'),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      '1:59',
                                      style: TextStyle(
                                          color: HexColor('#43ABFB'),
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 6),
                                  width: 40,
                                  height: 20,
                                  color: HexColor('#43ABFB'),
                                  child: const Center(
                                    child: Text(
                                      'BAR',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 36),
                            child: Text(
                              getProductName(widget.orderDetail[index]),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  widget.orderDetail[index].quantity == 1
                                      ? null
                                      : widget.orderDetail[index].quantity--;
                                });
                              },
                              child: Image.asset(
                                'assets/images/minus.png',
                                scale: 1.2,
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '${widget.orderDetail[index].quantity}',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w800),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  widget.orderDetail[index].quantity++;
                                });
                              },
                              child: Image.asset(
                                'assets/images/plus.png',
                                scale: 1.2,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 9),
                          child: const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22, vertical: 12),
                                    backgroundColor: HexColor('#FF3131')),
                                onPressed: () {
                                  setState(() {
                                    widget.orderDetail.removeAt(index);
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      'ELIMINA PRODOTTO',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                          'assets/images/cestino.png'),
                                    )
                                  ],
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                        width: 1.4, color: Colors.grey),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22, vertical: 12),
                                    backgroundColor: HexColor('#EBEBEB')),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text(
                                                'INSERISCI NOTE PRODOTTO.'),
                                            content: TextFormField(
                                              initialValue: '',
                                              onChanged: (value) {
                                                // note = value;
                                                Navigator.pop(context);
                                              },
                                              maxLines: 10,
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton.icon(
                                                      style: ElevatedButton.styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          backgroundColor:
                                                              HexColor(
                                                                  '#CDD4D9')),
                                                      onPressed: () {},
                                                      icon: Image.asset(
                                                        'assets/images/pen3.png',
                                                      ),
                                                      label: const Text(
                                                        'CONFERMA',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  TextButton.icon(
                                                      style: ElevatedButton.styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          backgroundColor:
                                                              HexColor(
                                                                  '#43ABFB')),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(
                                                        Icons.arrow_back_sharp,
                                                        color: Colors.white,
                                                      ),
                                                      label: const Text(
                                                        'INDIETRO',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ));
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      'NOTE',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        'assets/images/pen.png',
                                        scale: 7,
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor('#4BC59E'),
                ),
                width: 100,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'AGGIUNGI',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'PRODOTTO',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateDetail(
                            orderDetail: widget.orderDetail,
                            tableID: widget.tableID,
                            userID: userID!,
                            orderID: widget.orderID,
                            orderStateID: defaultOrderState!,
                            products: products,
                            categories: categories,
                            coperti: widget.coperti)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor('#438C71'),
                ),
                width: 100,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'AGGIUNGI',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'CATEGORIA',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmOrder(
                              orderDetail: widget.orderDetail,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor('#98B8BA'),
                ),
                width: 100,
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'COMPLETA',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'COMANDA',
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