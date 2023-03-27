import 'package:meari/pages/orders/confirmProduct.dart';
import 'package:meari/pages/orders/chooseCategory.dart';

Map<dynamic, dynamic> homePageData = {};
List orders = [];
List products = [];
List categories = [];
List orderDetails = [];
List tables = [];
int? userID;
String userName = '';
int? defaultOrderState;
DateTime date = DateTime.parse(DateTime.now().toString());
var mm = date.month;
var day = date.day;
var yy = date.year;
var hh = date.hour;
var min = date.minute;
String today = '$yy/$mm/$day - $hh:$min';
