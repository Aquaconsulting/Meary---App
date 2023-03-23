import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/confirmProduct.dart';
import 'package:meari/pages/orders/detail.dart';

class UpdateOrderPage extends StatefulWidget {
  UpdateOrderPage(
      {super.key,
      required this.currentOrder,
      required this.orderDetail,
      required this.userID});
  dynamic currentOrder;
  List orderDetail;
  int userID;
  @override
  State<UpdateOrderPage> createState() => _UpdateOrderPageState();
}

class _UpdateOrderPageState extends State<UpdateOrderPage> {
  List tables = homePageData['tables'];
  late String note = widget.currentOrder['note'];
  late String detailNote = widget.orderDetail[0]['note'];

  late dynamic value = widget.currentOrder['table']['id'].toString();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  updateOrder() {
    try {
      Services.updateOrder(widget.currentOrder, int.parse(value), note,
              widget.currentOrder['id'])
          .then((result) {
        result
            // SE LA L'API RITORNA TRUE
            ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Ordine Modificato con successo.'),
              ))
            : showDialog(
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
      });
    } catch (e) {}
  }

  updateOrderDetail() {
    try {
      Services.updateOrderDetail(details, detailNote, 0).then((result) {
        result
            // SE LA L'API RITORNA TRUE
            ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Ordine Modificato con successo.'),
              ))
            : print(result);
        // : showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //           title: const Text('Qualcosa è andato storto.'),
        //           content:
        //               const Text('Controlla la tua connessione e riprova.'),
        //           actions: [
        //             TextButton(
        //                 onPressed: (() {
        //                   Navigator.pop(context);
        //                 }),
        //                 child: const Text('Chiudi'))
        //           ],
        //         ));
      });
    } catch (e) {}
  }

  Widget filterItem(index, index2) {
    if (categories[index]['id'] == products[index2]['category_id']) {
      return ListTileItemUpdate(
          product: products[index2],
          orderID: widget.currentOrder['id'],
          orderStateID: 1,
          userID: widget.userID,
          counter: 1);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica Ordine'),
        leading: IconButton(
            onPressed: () {
              //SVUOTA ARRAY DEI PRODOTTI
              details = [];
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded)),
      ),
      // body: SingleChildScrollView(
      //   child: Container(
      //     margin: const EdgeInsets.all(14),
      //     child: Form(
      //         key: _formKey,
      //         child: Column(
      //           children: [
      //             const Text('Cambia tavolo:', style: TextStyle(fontSize: 18)),
      //             SmartSelect<String>.single(
      //                 validation: (value) {
      //                   if (value.isEmpty) {
      //                     return 'Compila questo campo';
      //                   } else {
      //                     return '';
      //                   }
      //                 },
      //                 selectedValue: value,
      //                 title: 'Seleziona un tavolo',
      //                 choiceItems: List.generate(
      //                     tables.length,
      //                     (index) => S2Choice<String>(
      //                         value: '${tables[index]['id']}',
      //                         title:
      //                             '${tables[index]['name']}, posti: ${tables[index]['seats']}')),
      //                 onChange: (state) {
      //                   setState(() {
      //                     value = state.value;
      //                   });
      //                 }),
      //             Container(
      //               margin: const EdgeInsets.only(top: 30, bottom: 10),
      //               child: const Text(
      //                 'Note:',
      //                 style: TextStyle(fontSize: 20),
      //               ),
      //             ),
      //             TextFormField(
      //               onChanged: (value) {
      //                 note = value;
      //               },
      //               initialValue: widget.currentOrder['note'],
      //               decoration: const InputDecoration(
      //                 border: OutlineInputBorder(),
      //                 hintText: 'Inserire nota comanda...',
      //               ),
      //               keyboardType: TextInputType.multiline,
      //               maxLines: 4,
      //               validator: (value) {
      //                 if (value!.isEmpty) {
      //                   return 'Compila questo campo';
      //                 }
      //               },
      //             ),
      //             Container(
      //               margin: const EdgeInsets.only(top: 20, bottom: 26),
      //               child: FloatingActionButton(
      //                 heroTag: 'btn2',
      //                 onPressed: () {
      //                   if (_formKey.currentState!.validate()) {
      //                     updateOrder();
      //                     _formKey.currentState!.save();
      //                     //funzione per chiudere la tastiera automaticamente
      //                     FocusManager.instance.primaryFocus?.unfocus();
      //                   }
      //                 },
      //                 child: const Icon(Icons.edit),
      //               ),
      //             ),
      //             //DIVIDER PER DISTINGUERE ORDER DA ORDER_DETAIL
      //             Row(children: const [
      //               Expanded(
      //                   child: Divider(
      //                 indent: 10,
      //                 endIndent: 6,
      //                 color: Colors.grey,
      //                 thickness: 1,
      //               )),
      //               Text("Modifica Prodotti"),
      //               Expanded(
      //                   child: Divider(
      //                 indent: 10,
      //                 endIndent: 6,
      //                 color: Colors.grey,
      //                 thickness: 1,
      //               )),
      //             ]),
      //             // Text(widget.orderDetail[1]['id'].toString())
      //             Form(
      //                 key: _formKey2,
      //                 child: Column(
      //                   children: [
      //                     ListView.builder(
      //                         shrinkWrap: true,
      //                         scrollDirection: Axis.vertical,
      //                         padding: const EdgeInsets.all(8),
      //                         itemCount: categories.length,
      //                         itemBuilder: (BuildContext context, int index) {
      //                           return Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text(
      //                                 categories[index]['name'],
      //                                 style: const TextStyle(
      //                                     fontSize: 20,
      //                                     fontWeight: FontWeight.w700),
      //                               ),
      //                               Wrap(
      //                                 children: List.generate(
      //                                     products.length,
      //                                     (index2) =>
      //                                         filterItem(index, index2)),
      //                               )
      //                             ],
      //                           );
      //                         }),
      //                     Container(
      //                       margin: const EdgeInsets.only(top: 20),
      //                       child: TextFormField(
      //                         onChanged: (value) {
      //                           detailNote = value;
      //                         },
      //                         decoration: const InputDecoration(
      //                           border: OutlineInputBorder(),
      //                           hintText: 'Inserire Dettagli comanda...',
      //                         ),
      //                         keyboardType: TextInputType.multiline,
      //                         maxLines: 4,
      //                         initialValue: widget.orderDetail[0]['note'],
      //                         validator: (value) {
      //                           if (value!.isEmpty) {
      //                             return 'Compila questo campo';
      //                           }
      //                         },
      //                       ),
      //                     ),
      //                     Container(
      //                       margin: const EdgeInsets.only(top: 20, bottom: 26),
      //                       child: FloatingActionButton(
      //                         heroTag: 'btn1',
      //                         onPressed: () {
      //                           if (_formKey2.currentState!.validate()) {
      //                             updateOrderDetail();
      //                             _formKey2.currentState!.save();
      //                             //funzione per chiudere la tastiera automaticamente
      //                             FocusManager.instance.primaryFocus?.unfocus();
      //                           }
      //                           print(details);
      //                         },
      //                         child: const Icon(Icons.edit),
      //                       ),
      //                     ),
      //                   ],
      //                 ))
      //           ],
      //         )),
      //   ),
      // ),
    );
  }
}

class ListTileItemUpdate extends StatefulWidget {
  ListTileItemUpdate({
    super.key,
    required this.counter,
    required this.product,
    required this.orderID,
    required this.orderStateID,
    required this.userID,
  });
  Map product = {};
  int orderID;
  int userID;
  int counter;

  int orderStateID;
  @override
  _ListTileItemUpdateState createState() => _ListTileItemUpdateState();
}

class _ListTileItemUpdateState extends State<ListTileItemUpdate> {
  late int _itemCount = widget.counter;
  double finalPrice = 0.00;
  double currentPrice = 0.00;
  setCounter() {
    details.removeWhere((item) => item.productID == widget.product['id']);
    details.add(OrderDetail(
        widget.orderID,
        widget.orderStateID,
        double.parse(widget.product['price']),
        _itemCount,
        widget.product['id']));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Container(
          width: 100,
          child: Text(widget.product['name']),
        ),
        trailing: SizedBox(
          width: 120,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    // IMPEDISCI DI ANDARE SOTTO ZERO
                    _itemCount == 0 ? null : _itemCount--;
                    // SE IL PRODOTTO E' GIA STATO SELEZIONATO, NON AGGIUNGERLO E AUMENTA\DIMINUISCI SOLO LA QUANTITA'
                    setCounter();

                    // SE IL COUNTER E' A 0 RIMUOVI IL PRODOTTO DALL'ARRAY
                    if (_itemCount == 0) {
                      details.removeWhere(
                          (item) => item.productID == widget.product['id']);
                    }
                  });
                },
              ),
              Text(_itemCount.toString()),
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _itemCount++;
                      // SE IL PRODOTTO E' GIA STATO SELEZIONATO, NON AGGIUNGERLO E AUMENTA\DIMINUISCI SOLO LA QUANTITA'
                      setCounter();
                    });
                  })
            ],
          ),
        ));
  }
}
