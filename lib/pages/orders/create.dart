import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/api/data.dart';
import 'package:awesome_select/awesome_select.dart';

class CreateOrderPage extends StatefulWidget {
  CreateOrderPage({
    super.key,
    required this.userID,
    required this.tables,
  });
  int userID;
  List tables = [];
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

  final _formKey = GlobalKey<FormState>();
  Object currentItem = {};
  TextEditingController noteController = TextEditingController();
  List tables = [];
  addOrder() {
    Services.addOrder(widget.userID, findId(currentItem, 'id'),
            noteController.text, DateTime.now(), 1)
        .then((result) {
      print(result);
      print(widget.userID);
      print(findId(currentItem, 'id'));
      print(noteController.text);
      print(DateTime.now());
      if (result == true) {
        setState(() {
          Navigator.pop(context);
        });
      }
    });
  }

  //funzine per prendere id del tavolo dalla select
  int findId(item, id) {
    return item[id];
  }

  String findName(item, name) {
    return item[name];
  }

  dynamic value = 'flutter';

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
                    selectedValue: value,
                    title: 'Seleziona un tavolo',
                    choiceItems: List.generate(
                        widget.tables.length,
                        (index) => S2Choice<String>(
                            value: tables[index]['id'].toString(),
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
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addOrder();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
