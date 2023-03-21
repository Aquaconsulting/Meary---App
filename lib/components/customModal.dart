import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meari/api/apiServices.dart';
import 'package:meari/components/customAppBar.dart';
import 'package:meari/constant.dart';

class CustomModal extends StatefulWidget {
  CustomModal({super.key, required this.orderID});
  int orderID;
  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  int? value;
  changeTable() {
    try {
      Services.changeTable(widget.orderID, value!).then((result) {
        print(result);
        if (result) {
          Navigator.pop(context);
          //SVUOTA ARRAY DEI PRODOTTI
          details = [];
        } else {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambia Tavolo'),
      content: SingleChildScrollView(
          child: Wrap(
        children: List.generate(
            tables.length,
            (index) => InkWell(
                  onTap: () {
                    value = tables[index]['id'];
                    changeTable();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: HexColor('#4BC59E'),
                        borderRadius: BorderRadius.circular(8)),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    height: 110,
                    width: 110,
                    child: Center(
                      child: Text(
                        tables[index]['id'].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                  ),
                )),
      )),
      actions: [
        TextButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            child: Center(
              child: Text(
                'Chiudi',
                style: TextStyle(color: HexColor('#4BC59E')),
              ),
            ))
      ],
    );
  }
}
