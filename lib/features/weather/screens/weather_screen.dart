import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_event.dart';
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_state.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_bloc.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_event.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_state.dart';
import 'package:active_ecommerce_flutter/features/weather/screens/add_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../custom/device_info.dart';
import '../../../my_theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late var savedPrimaryData;
  late var savedSecondaryData;

  Future<void> getPrimaryData() async {
    var PrimaryLocationDataBox =
        Hive.box<PrimaryLocation>('primaryLocationBox');

    savedPrimaryData = PrimaryLocationDataBox.get('locationData');
  }

  Future<void> getSecondaryData() async {
    var SecondaryLocationDataBox =
        Hive.box<SecondaryLocations>('secondaryLocationsBox');

    savedSecondaryData = SecondaryLocationDataBox.get('locationData');
  }

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
  late String dropdownValue;
  // List<String> dropdownList = [];
  Set<String> dropdownSet = {};

  _launchURL(url) async {
    // print('clicked');
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch';
    }
  }

  String formatDate(String inputDate) {
    // Parse inputDate into a DateTime object
    DateTime parsedDate = DateTime.parse(inputDate);
    // print('input: $inputDate');

    // Define month weatherImages
    List<String> months = [
      '', // Empty string to make months list 1-indexed
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
      'Nov', 'Dec'
    ];

    // Extract day, month, and year components
    int day = parsedDate.day;
    int month = parsedDate.month;

    // Format the output string as '2 Oct'
    String formattedDate = '$day ${months[month]}';

    return formattedDate;
  }

  Future fetchDataFromHive() async {
    var PrimaryLocationDataBox =
        Hive.box<PrimaryLocation>('primaryLocationBox');

    savedPrimaryData = PrimaryLocationDataBox.get('locationData');

    var SecondaryLocationDataBox =
        Hive.box<SecondaryLocations>('secondaryLocationsBox');

    savedSecondaryData = SecondaryLocationDataBox.get('locationData');

    // print('fetched hive data');

    return [savedPrimaryData, savedSecondaryData];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
          // key: homeData.scaffoldKey,
          // drawer: const MainDrawer(),
          backgroundColor: Colors.transparent,
          appBar: buildCustomAppBar(context),
          body: bodycontent(),
          floatingActionButton: (showFloatingActionButton)
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: MyTheme.accent_color,
                  onPressed: () {
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
    var weatherImage = "assets/weather.png";

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Container(
          //       height: 44,
          //       width: MediaQuery.of(context).size.width,
          //       decoration: BoxDecoration(
          //         border: Border.all(color: MyTheme.textfield_grey),
          //         color: MyTheme.light_grey,
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       child: Row(
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(left: 20),
          //             child: Text(
          //               "577511",
          //               style: TextStyle(
          //                   fontWeight: FontWeight.bold, fontSize: 15),
          //             ),
          //           )
          //         ],
          //       )),
          // ),
          BlocBuilder<WeatherSectionBloc, WeatherSectionState>(
            builder: (context, state) {
              if (state is LoadingSection)
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
              if (state is WeatherSectionDataReceived) {
                for (var data in state.responseData) {
                  if (data != null) {
                    dropdownSet.add(data.locationName);
                    // print('object added : ${data.locationName}');
                  }
                }
                List<String> dropdownList = dropdownSet.toList();
                dropdownValue = dropdownList[index];
                // print('dropdown value: $dropdownValue');
                // print(
                //     'object : ${state.responseData[0]!.locationName == dropdownValue}');
                return Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: Container(
                    //       height: 44,
                    //       width: MediaQuery.of(context).size.width,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: MyTheme.textfield_grey),
                    //         color: MyTheme.light_grey,
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(left: 20),
                    //             child: Text(
                    //               state.responseData[0]!.locationName,
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 15),
                    //             ),
                    //           )
                    //         ],
                    //       )),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
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
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Forecast',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: MyTheme.dark_font_grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          BlocListener<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherSreenDataReceived) {
                // print('state is WeatherSreenDataReceived');
                setState(() {
                  showFloatingActionButton = true;
                });
              } else if (state is Loading) {
                // print('state is LOADING');
              } else {
                // print('state: $state');
                // BlocProvider.of<WeatherBloc>(context).add(
                //   WeatherSectionInfoRequested(),
                // );
              }
              // if (state is ScreenNoLocationDataFound) {
              //   ToastComponent.showDialog('No Location Data Found',
              //       gravity: Toast.center, duration: Toast.lengthLong);
              // }
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
                            image: weatherImage,
                            // min: '--',
                            // max: '--',
                            desc: '--',
                          ),
                          WeatherDayCard(
                            context: context,
                            date: ' -- ',
                            image: weatherImage,
                            // min: '--',
                            // max: '--',
                            desc: '--',
                          ),
                          WeatherDayCard(
                            context: context,
                            date: ' -- ',
                            image: weatherImage,
                            // min: '--',
                            // max: '--',
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
                          'No Location Data Found',
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
                            'Add Location',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          onPressed: () {
                            // print('tapped');
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
                                image: weatherImage,
                                desc: responseData['day0']['desc'],
                              ),
                              WeatherDayCard(
                                context: context,
                                date: formatDate(responseData['day1']['date']),
                                image: weatherImage,
                                desc: responseData['day1']['desc'],
                              ),
                              WeatherDayCard(
                                context: context,
                                date: formatDate(responseData['day2']['date']),
                                image: weatherImage,
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
                          image: weatherImage,
                          // min: '--',
                          // max: '--',
                          desc: '--',
                        ),
                        WeatherDayCard(
                          context: context,
                          date: ' -- ',
                          image: weatherImage,
                          // min: '--',
                          // max: '--',
                          desc: '--',
                        ),
                        WeatherDayCard(
                          context: context,
                          date: ' -- ',
                          image: weatherImage,
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
            padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Satellite View',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: MyTheme.dark_font_grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10, bottom: 20),
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
        // Padding(
        //   padding: const EdgeInsets.only(left: 4, bottom: 5),
        //   child: Text(
        //     title,
        //     style: TextStyle(
        //         // color: MyTheme.accent_color,
        //         fontSize: 12,
        //         fontWeight: FontWeight.w500,
        //         letterSpacing: .5,
        //         fontFamily: 'Poppins'),
        //   ),
        // ),
        InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              // borderSide: BorderSide(
              //   color: MyTheme.textfield_grey,
              // ),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Color(0xff4C7B10),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current Weather',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: MyTheme.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 25,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                color: MyTheme.light_grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${currentTemperature}°',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60,
                              color: MyTheme.dark_font_grey,
                            ),
                          ),
                          Text(
                            'C',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: MyTheme.dark_font_grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            right: 20, top: 15, bottom: 20, left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentDesc,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              'Humidity: ${currentHumidity}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              'Wind: ${currentWind}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        )),
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
  final String image;
  // final String min;
  // final String max;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: MyTheme.light_grey,
      ),
      height: MediaQuery.of(context).size.height / 4.6,
      width: MediaQuery.of(context).size.width / 4,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff4C7B10),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            padding: const EdgeInsets.all(8),
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                image,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              desc.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9.5,
                color: Colors.grey[700],
              ),
            ),
          )
        ],
      ),
    );
  }
}
