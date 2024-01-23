// translation done.

import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_state.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_bloc.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_event.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_state.dart';
import 'package:active_ecommerce_flutter/features/weather/screens/add_location.dart';
import 'package:active_ecommerce_flutter/utils/functions.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../custom/device_info.dart';
import '../../../my_theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  void initState() {
    super.initState();
    BlocProvider.of<WeatherBloc>(context).add(
      WeatherSreenDataRequested(),
    );
    BlocProvider.of<WeatherSectionBloc>(context).add(
      WeatherSectionDataRequested(),
    );
  }

  bool showFloatingActionButton = false;
  int index = 0;
  // late String dropdownValue;
  // List<String> dropdownList = [];
  Set<String> dropdownSet = {};

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
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: buildCustomAppBar(context),
          body: bodycontent(),
          floatingActionButton: (showFloatingActionButton)
              ? FloatingActionButton(
                  child: Image.asset(
                    "assets/add 2.png",
                    // height: 50,
                  ),
                  backgroundColor: MyTheme.accent_color,
                  onPressed: () {
                    setState(() {
                      index = 0;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddWeatherLocation()),
                    );
                  })
              : SizedBox.shrink()),
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 30,
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.weather_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  // margin: EdgeInsets.only(right: 18),
                  height: 30,
                  child: Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                        color: MyTheme.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bodycontent() {
    // var weatherImage = "assets/weather.png";

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          BlocBuilder<WeatherSectionBloc, WeatherSectionState>(
            builder: (context, state) {
              if (state is LoadingSection)
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: IgnorePointer(
                        ignoring: true,
                        child: DropdownButtonWidget(
                            // 'Select Location',
                            [
                              DropdownMenuItem<String>(
                                value: '-----',
                                child: Text('-----'),
                              )
                            ],
                            '-----', (value) {
                          setState(() {});
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 0, bottom: 7),
                      child: CurrentWeatherWidget(
                        currentTemperature: '--',
                        currentDesc: '--',
                        currentHumidity: '--',
                        currentWind: '--',
                      ),
                    ),
                  ],
                );
              if (state is WeatherSectionDataReceived) {
                dropdownSet.clear();
                List<String> dropdownList = [];
                late String dropdownValue;
                for (var data in state.responseData) {
                  if (data != null &&
                      dropdownSet.length < 3 &&
                      !dropdownSet.contains(data.locationName)) {
                    dropdownSet.add(data.locationName);
                    //
                  }
                }
                dropdownList = dropdownSet.toList();
                dropdownValue = dropdownList[index];
                //
                // print(
                //     'object : ${state.responseData[0]!.locationName == dropdownValue}');
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      child: DropdownButtonWidget(
                          // 'Select Location',
                          dropdownList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          dropdownValue, (value) {
                        setState(() {
                          dropdownValue = value;
                          var valueofIndex = dropdownList.indexOf(value);
                          index = valueofIndex;
                        });
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 0, bottom: 7),
                      child: CurrentWeatherWidget(
                        currentTemperature: state
                            .responseData[index]!.currentData.tempC
                            .toInt()
                            .toString(),
                        currentDesc: state
                            .responseData[index]!.currentData.condition.text,
                        // currentDesc: 'Sunny patchy weather',
                        currentHumidity: state
                            .responseData[index]!.currentData.humidity
                            .toString(),
                        currentWind: state
                            .responseData[index]!.currentData.windKph
                            .toString(),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        height: 44,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: MyTheme.textfield_grey),
                          color: MyTheme.light_grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "------",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            )
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: CurrentWeatherWidget(
                      currentTemperature: '--',
                      currentDesc: '--',
                      currentHumidity: '--',
                      currentWind: '--',
                    ),
                  ),
                ],
              );
            },
          ),
          BlocListener<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherSreenDataReceived) {
                setState(() {
                  showFloatingActionButton = true;
                });
              }
            },
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is Loading)
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherDayCard(
                            context: context,
                            date: ' -- ',
                            image: null,
                            desc: '--',
                          ),
                          WeatherDayCard(
                            context: context,
                            date: ' -- ',
                            image: null,
                            desc: '--',
                          ),
                          WeatherDayCard(
                            context: context,
                            date: ' -- ',
                            image: null,
                            desc: '--',
                          ),
                        ]),
                  );
                if (state is ScreenNoLocationDataFound)
                  return Container(
                    // height: double.infinity,
                    // width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.no_location_found,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .5,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.accent_color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.add_location_ucf,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddWeatherLocation(
                                          isPrimaryLocation: true,
                                        )));
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                if (state is WeatherSreenDataReceived) {
                  var responseData = state.responseData[index]!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              WeatherDayCard(
                                context: context,
                                date: formatDate(responseData['day0']['date']),
                                image: weatherCodeToImage[responseData['day0']
                                    ['code']],
                                desc: responseData['day0']['desc'],
                              ),
                              WeatherDayCard(
                                context: context,
                                date: formatDate(responseData['day1']['date']),
                                image: weatherCodeToImage[responseData['day1']
                                    ['code']],
                                desc: responseData['day1']['desc'],
                              ),
                              WeatherDayCard(
                                context: context,
                                date: formatDate(responseData['day2']['date']),
                                image: weatherCodeToImage[responseData['day2']
                                    ['code']],
                                desc: responseData['day2']['desc'],
                              ),
                            ]),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WeatherDayCard(
                          context: context,
                          date: ' -- ',
                          image: null,
                          // min: '--',
                          // max: '--',
                          desc: '--',
                        ),
                        WeatherDayCard(
                          context: context,
                          date: ' -- ',
                          image: null,
                          // min: '--',
                          // max: '--',
                          desc: '--',
                        ),
                        WeatherDayCard(
                          context: context,
                          date: ' -- ',
                          image: null,
                          // min: '--',
                          // max: '--',
                          desc: '--',
                        ),
                      ]),
                );
              },
            ),
          ),

          //Satellite View
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 5, bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.satellite_view,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: MyTheme.dark_font_grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 5, bottom: 20),
            child: InkWell(
              onTap: () async {
                _launchURL('https://zoom.earth/');
              },
              child: Image.asset("assets/satelite.png"),
            ),
          ),
        ],
      ),
    );
  }

  Column DropdownButtonWidget(
      // String title,
      List<DropdownMenuItem<String>>? itemList,
      String dropdownValue,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            filled: true,
            fillColor: MyTheme.light_grey,
            contentPadding: EdgeInsets.only(left: 20, right: 10),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            underline: SizedBox(),
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            onChanged: (String? value) {
              onChanged(value!);
            },
            items: itemList,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  ElevatedButton ElevatedButtonWidget(title, onTap) {
    return ElevatedButton(
        onPressed: onTap,
        child: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyTheme.light_grey,
          foregroundColor: Color(0xff4C7B10),
          textStyle: TextStyle(
            // fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }
}

class CurrentWeatherWidget extends StatelessWidget {
  const CurrentWeatherWidget({
    super.key,
    required this.currentTemperature,
    required this.currentDesc,
    required this.currentHumidity,
    required this.currentWind,
  });

  final String currentTemperature;
  final String currentDesc;
  final String currentHumidity;
  final String currentWind;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          color: Color(0xff4C7B10),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.current_weather,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: MyTheme.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 25,
              child: Container(
                // padding: EdgeInsets.only(bottom: 5),
                color: MyTheme.light_grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$currentTemperature°',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              color: MyTheme.dark_font_grey,
                            ),
                          ),
                          Text(
                            'C',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: MyTheme.dark_font_grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              right: 20, top: 0, bottom: 0, left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 211,
                                child: Text(
                                  currentDesc,
                                  maxLines: 2,
                                  // 'Sunny patchy weather', // 'Sunny patchy weather
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.humidity}: $currentHumidity',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.wind}: $currentWind',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDayCard extends StatelessWidget {
  const WeatherDayCard({
    super.key,
    required this.context,
    required this.date,
    required this.image,
    // required this.min,
    // required this.max,
    required this.desc,
  });

  final BuildContext context;
  final String date;
  final String? image;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: MyTheme.light_grey,
      ),
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width / 4.15,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff4C7B10),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9), topRight: Radius.circular(9)),
            ),
            padding: const EdgeInsets.all(6),
            child: Center(
              child: Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: MyTheme.white,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            // child: Image.asset(
            //   image,
            //   fit: BoxFit.fitWidth,
            // ),
            child: image == null
                ? Icon(Icons.block)
                : CachedNetworkImage(imageUrl: image!),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              desc.toUpperCase(),
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(),
        ],
      ),
    );
  }
}
