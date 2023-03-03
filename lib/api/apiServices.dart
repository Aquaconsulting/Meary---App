import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meari/api/data.dart';

class Services {
  static const apiUrl = 'http://10.0.2.2:8000/api/orders/';
  // static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  // static const _GET_ALL_ACTION = 'GET_ALL';
  // static const _ADD_EMP_ACTION = 'ADD_EMP';
  // static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  // static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  static Future<String> addOrder(int userID, int tableID, String note,
      DateTime date, int orderStateID) async {
    try {
      var map = Map<String, dynamic>();
      map['user_id'] = userID;
      map['table_id'] = tableID;
      map['note'] = note;
      map['date'] = date;
      map['order_state_id'] = orderStateID;
      final response = await http.post(Uri.parse(apiUrl), body: map);
      print('order add Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        print(response.body);
        return response.body;
      }
    } catch (e) {
      return e.toString();
    }
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
