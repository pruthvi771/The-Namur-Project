import 'package:active_ecommerce_flutter/features/profile/screens/friends_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/profile.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_bloc.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../my_theme.dart';
import '../weather/screens/weather_screen.dart';
import '../weather/bloc/weather_event.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  void initState() {
    super.initState();
    BlocProvider.of<WeatherBloc>(context).add(
      WeatherSectionInfoRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var temperature = '38°';
    var description = 'Rainy';
    var location = "@ Namur Pitlali";
    return Material(
      color: Colors.white,
      elevation: 3,
      child: Container(
        color: MyTheme.field_color,
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: MyTheme.green_light as Color,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Profile Image

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()));
                          },
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/girl.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //Friends and Groups text
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Friends()));
                          },
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "125 Friends",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        color: MyTheme.primary_color,
                                        letterSpacing: .5),
                                  ),
                                  // SizedBox(height: 1),
                                  Text(
                                    "5 Groups",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        color: MyTheme.primary_color,
                                        letterSpacing: .5,
                                        height: 1.5),
                                  ),

                                  Text(
                                    "3 Crops",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        color: MyTheme.primary_color,
                                        letterSpacing: .5,
                                        height: 1.5),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // ElevatedButton(
            //     onPressed: () {
            //       BlocProvider.of<WeatherBloc>(context).add(
            //         WeatherSectionInfoRequested(),
            //       );
            //     },
            //     child: Text('Click')),
            //Weather and Location
            BlocListener<WeatherBloc, WeatherState>(
              listener: (context, state) {
                if (state is WeatherSectionInfoReceived) {
                  print('state is WeatherSectionInfoReceived');
                }
                if (state is Loading) {
                  print('state is LOADING');
                }
                if (state is WeatherSectionInfoNotReceived) {
                  print('state is WeatherSectionInfoNotReceived');
                }
              },
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is Loading ||
                      state is WeatherSectionInfoNotReceived) {
                    return WeatherSection(
                      temperature: '-',
                      description: '-',
                      location: '---',
                    );
                  }
                  return WeatherSection(
                    temperature: temperature,
                    description: description,
                    location: location,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WeatherSection extends StatelessWidget {
  const WeatherSection({
    super.key,
    required this.temperature,
    required this.description,
    required this.location,
  });

  final String temperature;
  final String description;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
        child: Container(
          // height: 85,
          decoration: BoxDecoration(
              border: Border.all(
                color: MyTheme.green_light as Color,
              ),
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WeatherScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/weather.png'),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            temperature,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              color: MyTheme.primary_color,
                            ),
                          ),
                          Text(
                            description,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: MyTheme.primary_color,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Text(
                location,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  color: MyTheme.primary_color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
