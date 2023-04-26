import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meari/constant.dart';
import 'package:meari/pages/home.dart';
import 'package:meari/pages/login.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({super.key, this.action})
      : preferredSize = Size.fromHeight(70.0);
  final Size preferredSize;
  Function? action;
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(71.0),
      child: Container(
        margin: const EdgeInsets.only(top: 26),
        height: 71,
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 0.6),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                loading ? null : Navigator.pop(context, 'refresh');
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Image.asset(
                  'assets/images/back.png',
                  scale: 1,
                ),
              ),
            ),
            Image.asset(
              'assets/images/logo.png',
              scale: 2,
            ),
            Row(
              children: [
                seeLogout
                    ? InkWell(
                        onTap: () {
                          action!();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 26),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : Container(),
                InkWell(
                  onTap: () {
                    loading
                        ? null
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      userID: userID!,
                                    )));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Image.asset(
                      'assets/images/appbarSquare.png',
                      scale: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
