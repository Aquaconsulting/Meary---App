import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/api/data.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:meari/pages/orders/detail.dart';

class CreateOrderPage extends StatefulWidget {
  CreateOrderPage(
      {super.key,
      required this.userID,
      required this.tables,
      required this.products,
      required this.categories});
  int userID;
  List tables = [];
  List products = [];
  List categories = [];
  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tables = widget.tables;
  }

  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  Object currentItem = {};
  TextEditingController noteController = TextEditingController();
  List tables = [];
  int? orderID;
  addOrder() {
    try {
      Services.addOrder(widget.userID, int.parse(value), noteController.text,
              DateTime.now(), 1)
          .then((result) {
        if (result != false) {
          //SE LA L'API RITORNA L'OGGETTO PRENDO ID DELL'ORDINE APPENA CREATO E LO PASSO ALLA PAGINA SUCCESSIVA
          orderID = result['id'];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateDetail(
                        userID: widget.userID,
                        orderID: orderID!,
                        orderStateID: 1,
                        products: widget.products,
                        categories: widget.categories,
                      )));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ordine creato con successo'),
          ));
        } else {
          // SE INVECE RITORNA FALSE MOSTRA QUESTO
          showDialog(
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
        }
      });
    } catch (e) {}
  }

  dynamic value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea Ordine'),
      ),
      body: Container(
        margin: const EdgeInsets.all(18),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tavolo:',
                  style: TextStyle(fontSize: 20),
                ),
                SmartSelect<String>.single(
                    validation: (value) {
                      if (value.isEmpty) {
                        return 'Compila questo campo';
                      } else {
                        return '';
                      }
                    },
                    selectedValue: value.toString(),
                    title: 'Seleziona un tavolo',
                    choiceItems: List.generate(
                        widget.tables.length,
                        (index) => S2Choice<String>(
                            value: '${tables[index]['id']}',
                            title:
                                '${tables[index]['name']}, posti: ${tables[index]['seats']}')),
                    onChange: (state) {
                      setState(() {
                        value = state.value;
                        print(value);
                      });
                    }),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  child: const Text(
                    'Note:',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Inserire nota comanda...',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  controller: noteController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Compila questo campo';
                    }
                  },
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            addOrder();
            _formKey.currentState!.save();
            //funzione per chiudere la tastiera automaticamente
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
