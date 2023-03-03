import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:meari/api/api.dart';
import 'package:meari/api/data.dart';

class Services {
  static const apiUrl = 'http://10.0.2.2:8000/api/orders/';

  static Future<dynamic> addOrder(int userID, int tableID, String note,
      DateTime date, int orderStateID) async {
    String token = await API().getToken();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
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
    // try {
    //   var map = Map<String, dynamic>();
    //   map['user_id'] = userID;
    //   map['table_id'] = tableID;
    //   map['note'] = note;
    //   map['date'] = date;
    //   map['order_state_id'] = orderStateID;
    //   final response = await http.post(Uri.parse(apiUrl), body: map);
    //   print('order add Response: ${response.body}');
    //   if (200 == response.statusCode) {
    //     return response.body;
    //   } else {
    //     print(response.body);
    //     return response.body;
    //   }
    // } catch (e) {
    //   return e.toString();
    // }
  }

  // static Future<bool> updateEmployee(
  //     String empId, String firstName, String lastName) async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['action'] = _UPDATE_EMP_ACTION;
  //     map['id'] = empId;
  //     map['first_name'] = firstName;
  //     map['last_name'] = lastName;
  //     final response = await http.put(Uri.parse(ROOT + empId), body: map);
  //     print('updateEmployee Response: ${response.body}');
  //     if (200 == response.statusCode) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // static Future<bool> deleteEmployee(String empId) async {
  //   try {
  //     final response = await http.delete(Uri.parse(ROOT + empId));
  //     print('deleteEmployee Response: ${response.body}');
  //     if (200 == response.statusCode) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
