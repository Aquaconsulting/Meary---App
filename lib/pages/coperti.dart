import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/components/customModal.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/orders/chooseCategory.dart';

class AddPlace extends StatefulWidget {
  AddPlace(
      {super.key,
      required this.tableID,
      required this.userName,
      required this.userID,
      required this.orderID,
      required this.orderStateID,
      required this.products,
      required this.categories});
  String userName;
  int orderID;
  int userID;
  int tableID;
  int orderStateID;
  List<dynamic> products = [];
  List<dynamic> categories = [];
  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  int counter = 0;
  int coperti = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F3F3'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.only(top: 25),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 0.6, color: Colors.black))),
                  margin: const EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(DateTime.now().toString())
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('COMANDA'),
                        Text(
                          'TAVOLO',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border:
                              Border.all(width: 1, color: HexColor('#FF3131'))),
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
                        child: const Text('CAMBIA TAVOLO'))
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width - 50,
            height: 300,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 9,
                  offset: const Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: HexColor('#CDD4D9'),
                  ),
                  child: Image.asset(
                    'assets/images/COPERTI.png',
                    scale: 2,
                  ),
                ),
                Text(
                  'COPERTI TAVOLO ${widget.tableID.toString()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          coperti == 0 ? null : coperti--;
                        });
                      },
                      child: Image.asset(
                        'assets/images/minus.png',
                        scale: 1.2,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$coperti',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w800),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          coperti++;
                        });
                      },
                      child: Image.asset(
                        'assets/images/plus.png',
                        scale: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  thickness: 0.6,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: 280,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          backgroundColor: HexColor('#FF3131')),
                      onPressed: () {
                        setState(() {
                          coperti = 0;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('ELIMINA COPERTI'),
                          const SizedBox(
                            width: 16,
                          ),
                          Image.asset(
                            'assets/images/cestino.png',
                            scale: 1.2,
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width,
            height: 120,
            color: Colors.white,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#438C71')),
              child: const Text(
                'AGGIUNGI CATEGORIA',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateDetail(
                              orderDetail: [],
                              coperti: coperti,
                              tableID: widget.tableID,
                              userID: userID!,
                              orderID: widget.orderID,
                              orderStateID: 1,
                              products: widget.products,
                              categories: widget.categories,
                            )));
              },
            ),
          )
        ],
      ),
    );
  }
}
