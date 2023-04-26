import 'package:meari/pages/orders/confirmProduct.dart';
import 'package:meari/pages/orders/chooseCategory.dart';

Map<dynamic, dynamic> apiData = {};
List orders = [];
List products = [];
List categories = [];
List orderDetails = [];
List tables = [];
List destinations = [];
int? userID;
String? currentTable;
String userName = '';
int? defaultOrderState;
DateTime date = DateTime.parse(DateTime.now().toString());
var mm = date.month;
var day = date.day;
var yy = date.year;
var hh = date.hour;
var min = date.minute;
List product_states = [];
List coperto = [];
List idCustomCocktail = [];
String today = '$yy/$mm/$day';
//USANDO LA STESSA PAGINA DI CONFERMA PER UPDATE E STORE QUESTA VARIABILE SERVE PER STABILIRE LA ROTTA DA USARE
bool confirmUpdate = false;
bool loading = false;
bool seeLogout = false;
