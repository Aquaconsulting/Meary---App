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
        if (result) {
          Navigator.pop(context, 'refresh');
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
                            Navigator.pop(context, '');
                          }),
                          child: const Text('Chiudi'))
                    ],
                  ));
        }
      });
    } catch (e) {}
  }

  String color = '';

  getTableColour(index) {
    for (var element in orders) {
      if (element['table_id'] == tables[index]['id']) {
        String color = element['order_state']['state_colour'];

        return color;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: const Text('Cambia Tavolo'),
      content: SingleChildScrollView(
        child: Wrap(
            children: List.generate(
          tables.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: MediaQuery.of(context).size.width / 2 - 60,
            child: InkWell(
              onTap: () {
                value = tables[index]['id'];
                // SE IL TAVOLO E' LIBERO ALLORA PERMETTI IL CLICK
                if (getTableColour(index) == null ||
                    getTableColour(index) == '#4BC59E') {
                  changeTable();
                  setState(() {
                    currentTable = tables[index]['name'];
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor(getTableColour(index) ?? '#4BC59E'),
                    borderRadius: BorderRadius.circular(8)),
                height: 110,
                child: Center(
                  child: Text(
                    tables[index]['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        )),
      ),
      actions: [
        TextButton(
            onPressed: (() {
              Navigator.pop(context, '');
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
