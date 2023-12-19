import 'dart:async';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/friends_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/profile.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    _countOfFriends = getNumberOfFriends();
    BlocProvider.of<WeatherSectionBloc>(context).add(
      WeatherSectionDataRequested(),
    );
    // BlocProvider.of<HiveBloc>(context).add(
    //   HiveDataRequested(),
    // );
    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
      // HiveAppendAddress(context: context),
    );
  }

  late Future<BuyerData> _buyerUserDataFuture;
  late Future<List<Object>> _countOfFriends;

  Future<List<Object>> getNumberOfFriends() async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');
    if (savedData == null) {
      return [0, 0];
    }
    try {
      if (savedData.address[0].pincode.isEmpty) {
        throw Exception('Failed to load data');
      }

      int count = 0;
      int cropCount = 0;

      for (Land land in savedData.land) {
        cropCount += land.crops.length;
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('buyer')
              .where(FieldPath.documentId, isNotEqualTo: null)
              .where('profileData', isNotEqualTo: null)
              .get();

      List<DocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      for (var document in documents) {
        Map<String, dynamic> data = document.data()!;
        if (data['profileData']['address'].isNotEmpty) {
          Map<String, dynamic> data = document.data()!;
          if (data['profileData']['address'][0]['pincode'] ==
              savedData.address[0].pincode) {
            count++;
            print('count incremented');
          }
        }
      }

      return [cropCount, count - 1];
    } catch (e) {
      return [0, 0];
    }
  }

  Future<BuyerData> _getUserData() async {
    AuthUser user = AuthRepository().currentUser!;
    return FirestoreRepository().getBuyerData(userId: user.userId);
  }

  @override
  Widget build(BuildContext context) {
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
                                          : CachedNetworkImage(
                                              imageUrl: buyerUserData.photoURL!,
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
                                  child: FutureBuilder(
                                      future: _countOfFriends,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${snapshot.data![1]} Friends",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 13,
                                                        fontFamily: 'Poppins',
                                                        color: MyTheme
                                                            .primary_color,
                                                        letterSpacing: .5),
                                                  ),
                                                  // SizedBox(height: 1),
                                                  Text(
                                                    "0 Groups",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 13,
                                                        fontFamily: 'Poppins',
                                                        color: MyTheme
                                                            .primary_color,
                                                        letterSpacing: .5,
                                                        height: 1.5),
                                                  ),
                                                  Text(
                                                    "${snapshot.data![0]} Crops",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 13,
                                                        fontFamily: 'Poppins',
                                                        color: MyTheme
                                                            .primary_color,
                                                        letterSpacing: .5,
                                                        height: 1.5),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        if (snapshot.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              AppLocalizations.of(context)!
                                                  .add_address_to_see_this,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins',
                                                  color: MyTheme.primary_color,
                                                  letterSpacing: .5),
                                            )),
                                          );
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                        if (state is Error) {
                          ToastComponent.showDialog(state.error,
                              gravity: Toast.center,
                              duration: Toast.lengthLong);
                        }
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
                          if (state is LocationDataNotFoundinHive) {
                            return Expanded(
                              flex: 4,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WeatherScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, right: 8, bottom: 8),
                                  child: Container(
                                    // height: 85,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: MyTheme.green_light as Color,
                                        ),
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // Image.asset('assets/weather.png'),
                                              Icon(Icons.warning,
                                                  color: Colors.red),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '--',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                      fontFamily: 'Poppins',
                                                      color:
                                                          MyTheme.primary_color,
                                                    ),
                                                  ),
                                                  Text(
                                                    '--',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 11,
                                                      fontFamily: 'Poppins',
                                                      color:
                                                          MyTheme.primary_color,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '--',
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
                          if (state is WeatherSectionDataReceived) {
                            return WeatherSection(
                              temperature:
                                  '${state.responseData[0]!.currentData.tempC.toInt().toString()} °C',
                              description: state
                                  .responseData[0]!.currentData.condition.text,
                              location:
                                  '@${state.responseData[0]!.locationName}',
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
            decoration: BoxDecoration(
                border: Border.all(
                  color: MyTheme.green_light as Color,
                ),
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/weather.png'),
                        Text(
                          temperature,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            color: MyTheme.primary_color,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          color: MyTheme.primary_color,
                        ),
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: MyTheme.primary_color,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
