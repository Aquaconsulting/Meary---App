// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'dart:convert';

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    required this.orders,
    required this.tables,
  });

  List<Order> orders;
  List<Table> tables;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        tables: List<Table>.from(json["tables"].map((x) => Table.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "tables": List<dynamic>.from(tables.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    required this.id,
    required this.userId,
    required this.tableId,
    required this.date,
    required this.note,
    required this.orderStateId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  int tableId;
  DateTime date;
  String note;
  int orderStateId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        userId: json["user_id"],
        tableId: json["table_id"],
        date: DateTime.parse(json["date"]),
        note: json["note"],
        orderStateId: json["order_state_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "table_id": tableId,
        "date": date.toIso8601String(),
        "note": note,
        "order_state_id": orderStateId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Table {
  Table({
    required this.id,
    required this.name,
    required this.seats,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  int seats;
  String location;
  DateTime createdAt;
  DateTime updatedAt;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        id: json["id"],
        name: json["name"],
        seats: json["seats"],
        location: json["location"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "seats": seats,
        "location": location,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
