import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

class HexagonalWidget extends StatelessWidget {
  final double size;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double padding;
  final String image;
  final String title;
  final double cornerRadius;

  HexagonalWidget({
    this.size = 200.0,
    this.color = Colors.grey ,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
    this.padding = 8.0,
    this.image = "",
    this.title = "",
    this.cornerRadius = 8.0,
  });




  @override
  Widget build(BuildContext context) {
    var padding = 8.0;
    var w = (MediaQuery.of(context).size.width - 10 * padding) / 2;
    var h = 150.0;
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: HexagonWidget.flat(
                    color: MyTheme.field_color,
                    cornerRadius: 15,
                    width: w,
                    inBounds: true,
                    elevation: 3,
                    child: AspectRatio(
                      aspectRatio: HexagonType.FLAT.ratio,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          "assets/Frame6.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: HexagonWidget.flat(
                    width: w,
                    cornerRadius: 15,
                    color: Color(0xffC3FF77),
                    elevation: 3,
                    child: AspectRatio(
                      aspectRatio: HexagonType.POINTY.ratio,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          "assets/animal.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height:16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: HexagonWidget.flat(
                    color: MyTheme.field_color,
                    cornerRadius: 15,
                    width: w,
                    elevation: 3,
                    child: AspectRatio(
                      aspectRatio: HexagonType.FLAT.ratio,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          "assets/Frame6.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: HexagonWidget.flat(
                    width: w,
                    cornerRadius: 15,
                    color: MyTheme.field_color,
                    elevation: 3,
                    child: AspectRatio(
                      aspectRatio: HexagonType.POINTY.ratio,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          "assets/animal.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height:16),
            Padding(
              padding: EdgeInsets.all(padding),
              child: HexagonWidget.flat(
                  width: w,
                  cornerRadius: 15,
                  color: MyTheme.field_color,
                  elevation: 3,
                  child: Image.asset('assets/calender.png')
              ),
            ),
          ],
        ),
      );
    }}