import 'dart:async';

import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/friends_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/profile.dart';
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_event.dart';
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../my_theme.dart';
import '../weather/screens/weather_screen.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  void initState() {
    super.initState();
    _buyerUserDataFuture = _getUserData();
    BlocProvider.of<WeatherSectionBloc>(context).add(
      WeatherSectionDataRequested(),
    );
  }

  late Future<BuyerData> _buyerUserDataFuture;

  Future<BuyerData> _getUserData() async {
    AuthUser user = AuthRepository().currentUser!;
    return FirestoreRepository().getBuyerData(userId: user.userId);
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<WeatherSectionBloc>(context).add(
    //   WeatherSectionInfoRequested(),
    // );

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
        child: FutureBuilder(
            future: _buyerUserDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                BuyerData buyerUserData = snapshot.data as BuyerData;
                return Row(
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
                                      child: (buyerUserData.photoURL == null ||
                                              buyerUserData.photoURL == '')
                                          ? Image.asset(
                                              "assets/default_profile2.png",
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              buyerUserData.photoURL!,
                                              fit: BoxFit.cover,
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                    BlocListener<WeatherSectionBloc, WeatherSectionState>(
                      listener: (context, state) {
                        if (state is WeatherSectionDataReceived) {
                          print('state is WeatherSectionDataReceived');
                        } else if (state is LoadingSection) {
                          print('state is LOADING');
                        } else if (state is WeatherSectionDataNotReceived) {
                          // print('state is WeatherSectionDataNotReceived');
                        }
                        // else {
                        //   BlocProvider.of<WeatherBloc>(context).add(
                        //     WeatherSectionInfoRequested(),
                        //   );
                        // }
                      },
                      child:
                          BlocBuilder<WeatherSectionBloc, WeatherSectionState>(
                        builder: (context, state) {
                          if (state is LoadingSection) {
                            return WeatherSection(
                              temperature: '-',
                              description: '-',
                              location: '---',
                            );
                          }
                          if (state is WeatherSectionDataReceived) {
                            return WeatherSection(
                              temperature:
                                  '${state.responseData.currentData.tempC.toInt().toString()} °C',
                              description:
                                  state.responseData.currentData.condition.text,
                              location: '@Pitlali',
                            );
                          }
                          if (state is WeatherSectionDataNotReceived) {
                            return WeatherSection(
                              temperature: '==',
                              description: '==',
                              location: '==',
                            );
                          }
                          return WeatherSection(
                            temperature: '00',
                            description: '00',
                            location: '00',
                          );
                        },
                      ),
                    )
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
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
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => WeatherScreen()));
        },
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              color: MyTheme.primary_color,
                            ),
                          ),
                        ],
                      )
                    ],
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
      ),
    );
  }
}
