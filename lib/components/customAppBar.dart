import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  CustomAppBar({super.key}) : preferredSize = Size.fromHeight(71.0);
  final Size preferredSize;
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
                top: BorderSide(color: Colors.black, width: 0.6))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
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
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Image.asset(
                'assets/images/appbarSquare.png',
                scale: 1.1,
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(right: 22),
            //   height: 28,
            //   width: 28,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Container(
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(3),
            //               color: HexColor('#002115'),
            //             ),
            //             width: 12,
            //             height: 12,
            //           ),
            //           Container(
            //             width: 12,
            //             height: 12,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(3),
            //               color: HexColor('#43ABFB'),
            //             ),
            //           )
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Container(
            //             width: 12,
            //             height: 12,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(3),
            //               color: HexColor('#002115'),
            //             ),
            //           ),
            //           Container(
            //             width: 12,
            //             height: 12,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(3),
            //               color: HexColor('#002115'),
            //             ),
            //           )
            //         ],
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
