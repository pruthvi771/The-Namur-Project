import 'package:flutter/material.dart';

import '../../my_theme.dart';
import '../weather/weather_screen.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      child: Container(
        color: MyTheme.field_color,
        height: 85,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 55,
                    width: 90,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Image.asset("assets/girl.png"),
                  ),
                  Container(
                    height: 53,
                    width: 80,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "5 groups",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  letterSpacing: .5),
                            ),
                          ),
                          // SizedBox(height: 1),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "125 Friends\n & neighbors",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  color: MyTheme.primary_color,
                                  letterSpacing: .5,
                                  height: 1.5),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(
                height: 68,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WeatherScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /*  Text("Weather",
                            style: TextStyle(fontWeight: FontWeight.w500,
                                fontSize: 14,fontFamily: 'Poppins'),),*/
                          SizedBox(
                            width: 40,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Image.asset('assets/weather.png')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "@ Namur  pitlali",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Poppins'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
