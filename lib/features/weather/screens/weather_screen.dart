import 'package:active_ecommerce_flutter/features/weather/bloc/weather_bloc.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_event.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../custom/device_info.dart';
import '../../../my_theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  void initState() {
    super.initState();
    // fetchAll();
    BlocProvider.of<WeatherBloc>(context).add(
      WeatherSreenDataRequested(),
    );
  }

  bool _switchValue = false;

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
    print('input: $inputDate');

    // Define month names
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            // key: homeData.scaffoldKey,
            // drawer: const MainDrawer(),
            backgroundColor: Colors.transparent,
            appBar: buildCustomAppBar(context),
            body: buildBody(),
          ),
        ],
      ),
    );
  }

  RefreshIndicator buildBody() {
    return RefreshIndicator(
      color: MyTheme.white,
      backgroundColor: MyTheme.primary_color,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: bodycontent(),
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
    bool largeContainer = true;

    var data = '23 Oct';
    var name = "assets/weather.png";
    var data2 = '13';
    var data3 = '3';
    return SingleChildScrollView(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Pitlali 577511",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )
                    ],
                  )),
            ),
            BlocBuilder<WeatherBloc, WeatherState>(
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
                            image: name,
                            min: '--',
                            max: '--',
                            desc: '--',
                          ),
                          WeatherDayCard(
                            context: context,
                            date: ' -- ',
                            image: name,
                            min: '--',
                            max: '--',
                            desc: '--',
                          ),
                          WeatherDayCard(
                            context: context,
                            date: ' -- ',
                            image: name,
                            min: '--',
                            max: '--',
                            desc: '--',
                          ),
                        ]),
                  );
                if (state is WeatherSreenDataReceived) {
                  var responseData = state.responseData;
                  var currentTemp2 = 19.5;
                  var currentTemp = currentTemp2.toInt();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: ClipRRect(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.baseline,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  '$currentTemp°',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 60,
                                                    color:
                                                        MyTheme.dark_font_grey,
                                                  ),
                                                ),
                                                Text(
                                                  'C',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                    color:
                                                        MyTheme.dark_font_grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, top: 15, bottom: 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Clear sky patch',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.grey[800],
                                                      fontFamily: 'Courier New',
                                                    ),
                                                  ),
                                                ),
                                                Text('Humidity: 23.76',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Colors.grey[800],
                                                    )),
                                                Text('Wind: 23.98',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Colors.grey[800],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, top: 10, bottom: 10),
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              WeatherDayCard(
                                context: context,
                                date: formatDate(responseData['day0']['date']),
                                image: name,
                                min: responseData['day0']['mintemp'].toString(),
                                max: responseData['day0']['maxtemp'].toString(),
                                desc: responseData['day0']['desc'],
                              ),
                              WeatherDayCard(
                                context: context,
                                date: formatDate(responseData['day1']['date']),
                                image: name,
                                min: responseData['day1']['mintemp'].toString(),
                                max: responseData['day1']['maxtemp'].toString(),
                                desc: responseData['day1']['desc'],
                              ),
                              WeatherDayCard(
                                context: context,
                                date: formatDate(responseData['day2']['date']),
                                image: name,
                                min: responseData['day2']['mintemp'].toString(),
                                max: responseData['day2']['maxtemp'].toString(),
                                desc: responseData['day2']['desc'],
                              ),
                            ]),
                      ],
                    ),
                  );
                }
                return Text('error');
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Expanded(
            //           child: Padding(
            //         padding: const EdgeInsets.only(right: 20),
            //         child: ElevatedButtonWidget(
            //           "Previous",
            //           () {},
            //         ),
            //       )),
            //       Expanded(
            //           child: Padding(
            //         padding: const EdgeInsets.only(left: 20),
            //         child: ElevatedButtonWidget(
            //           "Next",
            //           () {},
            //         ),
            //       )),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text(
                "Details View",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              child: InkWell(
                onTap: () async {
                  _launchURL('https://zoom.earth/');
                },
                child: Image.asset("assets/satelite.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Text(
                "Satellite View",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
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

class WeatherDayCard extends StatelessWidget {
  const WeatherDayCard({
    super.key,
    required this.context,
    required this.date,
    required this.image,
    required this.min,
    required this.max,
    required this.desc,
  });

  final BuildContext context;
  final String date;
  final String image;
  final String min;
  final String max;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: MyTheme.light_grey,
      ),
      height: MediaQuery.of(context).size.height / 4,
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
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: MyTheme.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  image,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 12, right: 10, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        '$min° |',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Text(
                      ' $max°',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  desc.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.5,
                    color: Colors.grey[500],
                    fontFamily: 'Courier New',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
