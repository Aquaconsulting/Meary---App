import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meari/api/api.dart';
import 'package:meari/api/data.dart';
import 'package:meari/pages/orders/detail.dart';

class Services {
  static Future<dynamic> addOrder(int userID, int tableID, String note,
      DateTime date, int orderStateID) async {
    String token = await API().getToken();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/orders/'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userID,
          'table_id': tableID,
          'note': note,
          'date': date == null ? null : date.toIso8601String(),
          'order_state_id': orderStateID,
        }),
      );
      final Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<Map<String, dynamic>> addOrderDetail(
      List details, String note) async {
    String token = await API().getToken();

    List<Map<String, dynamic>>? finalDetail = [];
    finalDetail = [
      for (int i = 0; i < details.length; i++)
        {
          "order_id": "${details[i].orderID}",
          "product_id": "${details[i].productID}",
          "note": note,
          "quantity": "${details[i].quantity}",
          "price": "${details[i].price}",
          "order_state_id": "${details[i].orderStateID}"
        }
    ];
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/order_details/'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{"orderData": finalDetail}),
      );
      final Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } catch (e) {
      return {'error': e};
    }
  }
}
