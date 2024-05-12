import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/misc_bloc/misc_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_state.dart'
    as profileState;
import 'package:active_ecommerce_flutter/features/profile/screens/friends_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/profile.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_state.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
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
    BlocProvider.of<ProfileBloc>(context).add(
      ProfileDataRequested(),
    );
    BlocProvider.of<WeatherSectionBloc>(context).add(
      WeatherSectionDataRequested(),
    );
    BlocProvider.of<MiscBloc>(context).add(
      MiscDataRequested(),
    );
    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
  }

  _launchURL(url) async {
    //
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch';
    }
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
        child: Row(
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
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                            child: BlocBuilder<ProfileBloc,
                                profileState.ProfileState>(
                              builder: (context, state) {
                                if (state is profileState.ProfileDataReceived) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: state.buyerProfileData.photoURL !=
                                                null &&
                                            state.buyerProfileData.photoURL!
                                                .isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: state
                                                .buyerProfileData.photoURL!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/default_profile2.png",
                                            fit: BoxFit.cover,
                                          ),
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
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
                          child: BlocBuilder<MiscBloc, MiscState>(
                              builder: (context, state) {
                            if (state is MiscLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is MiscDataReceived) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${state.numberOfFriends} ${AppLocalizations.of(context)!.friends_and_neighbours}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              color: MyTheme.primary_color,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                      Text(
                                        "${state.numberOfCrops} ${AppLocalizations.of(context)!.crops}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            // fontSize: 13,
                                            fontFamily: 'Poppins',
                                            color: MyTheme.primary_color,
                                            letterSpacing: .5,
                                            height: 1.5),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
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
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Weather and Location
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  _launchURL('https://zoom.earth/');
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset("assets/satelite.png"),
                    ),
                    Positioned.fill(
                      child: Container(
                        // rounded borders
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: MyTheme.blue_grey.withOpacity(.5),
                        ),

                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.satellite_view,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: MyTheme.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            // BlocListener<WeatherSectionBloc, WeatherSectionState>(
            //   listener: (context, state) {
            //     if (state is WeatherSectionDataReceived) {
            //     } else if (state is LoadingSection) {
            //     } else if (state is WeatherSectionDataNotReceived) {
            //       //
            //     }
            //     if (state is Error) {
            //       ToastComponent.showDialog('Network error. Try again later',
            //           gravity: Toast.center, duration: Toast.lengthLong);
            //     }
            //   },
            //   child: BlocBuilder<WeatherSectionBloc, WeatherSectionState>(
            //     builder: (context, state) {
            //       if (state is LoadingSection) {
            //         return WeatherSection(
            //           temperature: '-',
            //           description: '-',
            //           location: '---',
            //           weatherCode: null,
            //         );
            //       }
            //       if (state is LocationDataNotFoundinHive) {
            //         return Expanded(
            //           flex: 4,
            //           child: GestureDetector(
            //             onTap: () {
            //               Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => WeatherScreen()));
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.only(
            //                   top: 8, right: 8, bottom: 8),
            //               child: Container(
            //                 // height: 85,
            //                 decoration: BoxDecoration(
            //                     border: Border.all(
            //                       color: MyTheme.green_light as Color,
            //                     ),
            //                     borderRadius: BorderRadius.circular(8)),
            //                 padding: const EdgeInsets.all(8),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   // crossAxisAlignment: CrossAxisAlignment.center,
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 5.0),
            //                       child: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceEvenly,
            //                         children: [
            //                           // Image.asset('assets/weather.png'),
            //                           Icon(Icons.warning, color: Colors.red),
            //                           Column(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.end,
            //                             children: [
            //                               Text(
            //                                 '--',
            //                                 style: TextStyle(
            //                                   fontWeight: FontWeight.w600,
            //                                   fontSize: 15,
            //                                   fontFamily: 'Poppins',
            //                                   color: MyTheme.primary_color,
            //                                 ),
            //                               ),
            //                               Text(
            //                                 '--',
            //                                 style: TextStyle(
            //                                   fontWeight: FontWeight.w600,
            //                                   fontSize: 11,
            //                                   fontFamily: 'Poppins',
            //                                   color: MyTheme.primary_color,
            //                                 ),
            //                               ),
            //                             ],
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                     Text(
            //                       '--',
            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w800,
            //                         fontSize: 15,
            //                         fontFamily: 'Poppins',
            //                         color: MyTheme.primary_color,
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       }
            //       if (state is WeatherSectionDataReceived) {
            //         return WeatherSection(
            //           temperature:
            //               '${state.responseData[0]!.currentData.tempC.toInt().toString()} °C',
            //           description:
            //               state.responseData[0]!.currentData.condition.text,
            //           location: '@${state.responseData[0]!.locationName}',
            //           weatherCode: state.responseData[0]!.weatherCode,
            //         );
            //       }
            //       if (state is WeatherSectionDataNotReceived) {
            //         return WeatherSection(
            //           temperature: '==',
            //           description: '==',
            //           location: '==',
            //           weatherCode: null,
            //         );
            //       }
            //       return WeatherSection(
            //         temperature: '00',
            //         description: '00',
            //         location: '00',
            //         weatherCode: null,
            //       );
            //     },
            //   ),
            // )
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
    required this.weatherCode,
  });

  final String temperature;
  final String description;
  final String location;
  final int? weatherCode;

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
                        weatherCode == null
                            ? Icon(Icons.warning, color: Colors.red)
                            : CachedNetworkImage(
                                imageUrl: weatherCodeToImage[weatherCode]!),
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
                          // fontSize: 13,
                          fontFamily: 'Poppins',
                          color: MyTheme.primary_color,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            // fontSize: 14,
                            fontFamily: 'Poppins',
                            color: MyTheme.primary_color,
                          ),
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
