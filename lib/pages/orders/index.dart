import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  double orderPrice = 0;
  getOrderPrice(int index) {
    for (var element in orderDetails) {
      if (element['order_id'] == orders[index]['id']) {
        orderPrice = double.parse(element['price']) * element['quantity'];
        return orderPrice;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F3F3'),
      appBar: CustomAppBar(),
      body: Column(
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
                                      fontSize: 30,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white)),
                              const Text('  '),
                              Text('ID-${orders[index]['id']}',
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              Container(
                                margin: const EdgeInsets.only(left: 22),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                width: 36,
                                height: 36,
                                child: Image.asset('assets/images/pen4.png'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                width: 36,
                                height: 36,
                                child: Image.asset('assets/images/redbin.png'),
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
                                  getOrderPrice(index).toString() != 'null'
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
