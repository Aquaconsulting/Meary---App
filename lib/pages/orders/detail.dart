import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:group_select/group_select.dart';

class CreateDetail extends StatefulWidget {
  CreateDetail(
      {super.key,
      required this.orderID,
      required this.orderStateID,
      required this.products,
      required this.categories});
  int orderID;
  int orderStateID;
  List<dynamic> products = [];
  List<dynamic> categories = [];
  @override
  State<CreateDetail> createState() => _CreateDetailState();
}

class _CreateDetailState extends State<CreateDetail> {
  final controller = SelectGroupController<int>(
    lang: LangBadge.enUS,
    multiple: true,
    dark: false,
  );

  //funzione che ritorna il prodotto assegnato a una categoria specifica
  prova(index, index2) {
    if (widget.categories[index]['id'] ==
        widget.products[index2]['category_id']) {
      return Item(
          title: widget.products[index2]['name'],
          value: widget.products[index2]['id'].toString());
    } else {
      return Item(title: '', value: '0');
    }
  }

  final groupController = SelectGroupController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio comanda'),
      ),
      body: Container(
          margin: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: GroupSelect<String>(
                title: 'Prodotti',
                activeColor: Colors.green,
                controller: groupController,
                groups: List.generate(
                    widget.categories.length,
                    (index) => Group(
                        title: widget.categories[index]['name'],
                        id: index.toString(),
                        items: List.generate(widget.products.length,
                            (index2) => prova(index, index2))))),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(widget.categories);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
