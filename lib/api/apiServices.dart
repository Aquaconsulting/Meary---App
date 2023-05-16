import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:meari/api/api.dart';
import 'package:meari/constant.dart';

class Services {
  static Future<dynamic> addFullOrder(
      int userID, int tableID, List details) async {
    String token = await API().getToken();
    print('entra qui? $userID $tableID');
    DateTime date = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse('https://meari.aquaconsulting.it/api/orders/'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userID,
          'table_id': tableID,
          'note': 'note',
          'date': date.toIso8601String(),
          'order_state_id': 1,
        }),
      );
      print('order added : ${response.body}');
      final Map<String, dynamic> orderAdded = json.decode(response.body);

      List<Map<String, dynamic>>? finalDetail = [];

      finalDetail = [
        for (int i = 0; i < details.length; i++)
          {
            "order_id": "${orderAdded['id']}",
            "product_id": "${details[i]['product_id']}",
            "note": details[i]['note'] == null
                ? 'nessuna nota'
                : "${details[i]['note']}",
            "quantity": "${details[i]['quantity']}",
            "price": "${details[i]['price']}",
            "order_state_id": orderAdded['order_state_id'],
            "custom_product": "${details[i]['custom_product']}"
          }
      ];
      print('finaldetail ADD FULL ORDER: ' + finalDetail.toString());
      try {
        final response = await http.post(
          Uri.parse('https://meari.aquaconsulting.it/api/order_details/'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token"
          },
          body: jsonEncode(<String, dynamic>{"orderData": finalDetail}),
        );

        json.decode(response.body);
        // updateWebSocket();
        return true;
      } catch (e) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // STORE ORDER
  static Future<dynamic> addOrder(int userID, int tableID, String note,
      DateTime date, int orderStateID) async {
    String token = await API().getToken();

    try {
      final response = await http.post(
        //  per emulatore android http://10.0.2.2:8000
        Uri.parse('https://meari.aquaconsulting.it/api/orders/'),
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
      print('PARSED: ${parsed.toString()}');
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
        Uri.parse('https://meari.aquaconsulting.it/api/orders/$id'),
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
        Uri.parse('https://meari.aquaconsulting.it/api/orders/$orderID'),
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

  // CHANGE TABLE
  static Future<dynamic> changeTable(int orderID, int value) async {
    String token = await API().getToken();

    try {
      final response = await http.put(
        Uri.parse('https://meari.aquaconsulting.it/api/changeTable'),
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

  //UPDATE NOTE
  static Future<dynamic> updateNote(int orderID, String note) async {
    String token = await API().getToken();

    try {
      final response = await http.put(
        Uri.parse('https://meari.aquaconsulting.it/api/updateNote'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{'orderID': orderID, 'note': note}),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

// STORE ORDER DETAIL
  static Future<dynamic> addOrderDetail(List details) async {
    String token = await API().getToken();

    List<Map<String, dynamic>>? finalDetail = [];

    finalDetail = [
      for (int i = 0; i < details.length; i++)
        {
          "order_id": "${details[i]['order_id']}",
          "product_id": "${details[i]['product_id']}",
          "note": details[i]['note'] == null
              ? 'nessuna nota'
              : "${details[i]['note']}",
          "quantity": "${details[i]['quantity']}",
          "price": "${details[i]['price']}",
          "order_state_id": details[i]['order_state_id'],
          "custom_product": "${details[i]['custom_product']}"
        }
    ];
    print('finaldetail: ' + finalDetail.toString());
    try {
      final response = await http.post(
        Uri.parse('https://meari.aquaconsulting.it/api/order_details/'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{"orderData": finalDetail}),
      );

      json.decode(response.body);
      // updateWebSocket();
      return true;
    } catch (e) {
      return false;
    }
  }

  // UPDATE ORDER DETAIL
  static Future<dynamic> updateOrderDetail(List details) async {
    String token = await API().getToken();
    List<Map<String, dynamic>>? finalDetail = [];
    finalDetail = [
      for (int i = 0; i < details.length; i++)
        {
          "id": "${details[i]['id']}",
          "order_id": "${details[i]['order_id']}",
          "product_id": "${details[i]['product_id']}",
          "note": details[i]['note'] == null
              ? "nessuna nota"
              : "${details[i]['note']}",
          "quantity": "${details[i]['quantity']}",
          "price": "${details[i]['price']}",
          "order_state_id": details[i]['order_state_id'],
          "custom_product": "${details[i]['custom_product']}"
        }
    ];

    try {
      final response = await http.put(
        Uri.parse('https://meari.aquaconsulting.it/api/order_details/0'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{"orderData": finalDetail}),
      );
      // updateWebSocket();
      return true;
    } catch (e) {
      return false;
    }
  }

  // DELETE ORDER DETAIL
  static Future<dynamic> deleteOrderDetail(int id) async {
    String token = await API().getToken();
    try {
      final response = await http.delete(
        Uri.parse('https://meari.aquaconsulting.it/api/order_details/$id'),
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

  // CREATE CUSTOM COCKTAIL
  static Future<dynamic> createCustomCocktail(request) async {
    String token = await API().getToken();

    try {
      final response = await http.post(
        Uri.parse('https://meari.aquaconsulting.it/api/createCustomCocktail'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{
          'name': request['name'],
          'price': request['price'],
          'description': request['desription'],
          'destination_id': request['destination_id'],
          'state': request['state'],
          'tempo_preparazione': request['tempo_preparazione'],
        }),
      );

      final Map<String, dynamic> parsed = json.decode(response.body);
      return parsed;
    } catch (e) {
      return false;
    }
  }

  // CHANGE STATE
  static Future<dynamic> changeState(int orderID) async {
    String token = await API().getToken();

    try {
      final response = await http.put(
        Uri.parse('https://meari.aquaconsulting.it/api/changeState/$orderID'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: jsonEncode(<String, dynamic>{"id": orderID}),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
