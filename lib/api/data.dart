// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'dart:convert';

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    required this.orders,
    required this.products,
    required this.tables,
  });

  List<Order> orders;
  List<Product> products;
  List<TableX> tables;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        tables:
            List<TableX>.from(json["tables"].map((x) => TableX.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
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
    required this.orderState,
    required this.table,
    required this.user,
  });

  int id;
  int userId;
  int tableId;
  DateTime date;
  String note;
  int orderStateId;
  DateTime createdAt;
  DateTime updatedAt;
  OrderState orderState;
  TableX table;
  User user;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        userId: json["user_id"],
        tableId: json["table_id"],
        date: DateTime.parse(json["date"]),
        note: json["note"],
        orderStateId: json["order_state_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        orderState: OrderState.fromJson(json["order_state"]),
        table: TableX.fromJson(json["table"]),
        user: User.fromJson(json["user"]),
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
        "order_state": orderState.toJson(),
        "table": table.toJson(),
        "user": user.toJson(),
      };
}

class OrderState {
  OrderState({
    required this.id,
    required this.currentState,
    required this.stateReference,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String currentState;
  String stateReference;
  DateTime createdAt;
  DateTime updatedAt;

  factory OrderState.fromJson(Map<String, dynamic> json) => OrderState(
        id: json["id"],
        currentState: json["current_state"],
        stateReference: json["state_reference"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "current_state": currentState,
        "state_reference": stateReference,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class TableX {
  TableX({
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

  factory TableX.fromJson(Map<String, dynamic> json) => TableX(
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

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.telephoneContact,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String firstName;
  String lastName;
  String telephoneContact;
  String email;
  DateTime? emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        telephoneContact: json["telephone_contact"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "telephone_contact": telephoneContact,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.destinationId,
    required this.cocktailBase,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  int id;
  String name;
  String price;
  String description;
  int categoryId;
  int destinationId;
  int cocktailBase;
  int state;
  DateTime createdAt;
  DateTime updatedAt;
  Category category;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        categoryId: json["category_id"],
        destinationId: json["destination_id"],
        cocktailBase: json["cocktail_base"],
        state: json["state"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "category_id": categoryId,
        "destination_id": destinationId,
        "cocktail_base": cocktailBase,
        "state": state,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "category": category.toJson(),
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}


// // To parse this JSON data, do
// //
// //     final data = dataFromJson(jsonString);

// import 'dart:convert';

// Data dataFromJson(String str) => Data.fromJson(json.decode(str));

// String dataToJson(Data data) => json.encode(data.toJson());

// class Data {
//   Data({
//     required this.orders,
//     required this.tables,
//   });

//   List<Order> orders;
//   List<TableX> tables;

//   factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
//         orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
//         tables:
//             List<TableX>.from(json["tables"].map((x) => TableX.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
//         "tables": List<dynamic>.from(tables.map((x) => x.toJson())),
//       };
// }

// class Order {
//   Order({
//     required this.id,
//     required this.userId,
//     required this.tableId,
//     required this.date,
//     required this.note,
//     required this.orderStateId,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   int id;
//   int userId;
//   int tableId;
//   DateTime date;
//   String note;
//   int orderStateId;
//   DateTime createdAt;
//   DateTime updatedAt;

//   factory Order.fromJson(Map<String, dynamic> json) => Order(
//         id: json["id"],
//         userId: json["user_id"],
//         tableId: json["table_id"],
//         date: DateTime.parse(json["date"]),
//         note: json["note"],
//         orderStateId: json["order_state_id"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "table_id": tableId,
//         "date": date.toIso8601String(),
//         "note": note,
//         "order_state_id": orderStateId,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }

// class TableX {
//   TableX({
//     required this.id,
//     required this.name,
//     required this.seats,
//     required this.location,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   int id;
//   String name;
//   int seats;
//   String location;
//   DateTime createdAt;
//   DateTime updatedAt;

//   factory TableX.fromJson(Map<String, dynamic> json) => TableX(
//         id: json["id"],
//         name: json["name"],
//         seats: json["seats"],
//         location: json["location"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "seats": seats,
//         "location": location,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }
