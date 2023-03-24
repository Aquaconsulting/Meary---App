import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:meari/api/api.dart';

class Services {
  // STORE ORDER
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
      return false;
    }
  }

  // UPDATE ORDER
  static Future<dynamic> updateOrder(
      dynamic order, int tableID, String note, int id) async {
    String token = await API().getToken();
    try {
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:8000/api/orders/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': order['user_id'],
          'table_id': tableID,
          'note': note,
          'date': order['date'] == null ? null : order['date'],
          'order_state_id': order['order_state_id'],
        }),
      );
      final Map<String, dynamic> parsed = json.decode(response.body);
      return true;
    } catch (e) {
      return false;
    }
  }

  // DELETE ORDER
  static Future<dynamic> deleteOrder(int orderID) async {
    String token = await API().getToken();
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/orders/$orderID'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> changeTable(int orderID, int value) async {
    String token = await API().getToken();

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/changeTable'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{'orderID': orderID, 'value': value}),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

// STORE ORDER DETAIL
  static Future<dynamic> addOrderDetail(List details, String note) async {
    String token = await API().getToken();

    List<Map<String, dynamic>>? finalDetail = [];
    finalDetail = [
      for (int i = 0; i < details.length; i++)
        {
          "order_id": "${details[i].order_id}",
          "product_id": "${details[i].product_id}",
          "note": note,
          "quantity": "${details[i].quantity}",
          "price": "${details[i].price}",
          "order_state_id": "${details[i].order_state_id}"
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

      json.decode(response.body);
      return true;
    } catch (e) {
      return false;
    }
  }

  // UPDATE ORDER DETAIL
  static Future<dynamic> updateOrderDetail(List details, String note) async {
    String token = await API().getToken();
    List<Map<String, dynamic>>? finalDetail = [];
    finalDetail = [
      for (int i = 0; i < details.length; i++)
        {
          "id": "${details[i]['id']}",
          "order_id": "${details[i]['order_id']}",
          "product_id": "${details[i]['product_id']}",
          "note": note,
          "quantity": "${details[i]['quantity']}",
          "price": "${details[i]['price']}",
          "order_state_id": "${details[i]['order_state_id']}"
        }
    ];
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/order_details/0'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{"orderData": finalDetail}),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
