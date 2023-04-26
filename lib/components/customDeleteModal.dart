import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DeleteModal extends StatefulWidget {
  DeleteModal({super.key, required this.function});
  Function function;
  @override
  State<DeleteModal> createState() => _DeleteModalState();
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

class _DeleteModalState extends State<DeleteModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sei sicuro di voler eliminare questo prodotto?'),
      content: const Text('Questa azione è irreversibile.'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: HexColor('#FF3131')),
                onPressed: () {
                  widget.function();
                },
                icon: Image.asset('assets/images/cestino.png'),
                label: const Text(
                  'ELIMINA',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton.icon(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    backgroundColor: HexColor('#43ABFB')),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.white,
                ),
                label: const Text(
                  'INDIETRO',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        )
      ],
    );
  }
}
