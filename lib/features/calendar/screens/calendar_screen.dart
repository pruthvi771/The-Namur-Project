import 'package:active_ecommerce_flutter/features/calendar/screens/calendar_add_crop.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/calender/cultivation_tip.dart';
import 'package:active_ecommerce_flutter/screens/calender/pest_control.dart';
import 'package:active_ecommerce_flutter/screens/calender/tutorial.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // HomePresenter homeData = HomePresenter();

  final DateTime currentDateTime = DateTime.now();
  late DateTime tenDaysAhead = currentDateTime.add(Duration(days: 10));

  late Future<CropCalendarData?> cropsForTrackingFuture;
  late Future cropDocumentForInfoFuture;

  int? selectedIndex;

  Future<CropCalendarData?> getCropsForTracking() async {
    var dataBox = Hive.box<CropCalendarData>('cropCalendarDataBox');

    var savedData = dataBox.get('calendar');

    if (savedData == null) {
      throw Exception('No data found in the box');
    }

    return savedData;
  }

  Future getCropDocForInfo({required String cropName}) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('calendar')
        .doc(cropName.toLowerCase())
        .get();

    if (userSnapshot.exists) {
      return userSnapshot.data();
    } else {
      return null;
    }
  }

  @override
  void initState() {
    cropDocumentForInfoFuture = getCropDocForInfo(cropName: 'onion');
    cropsForTrackingFuture = getCropsForTracking();
    // tenDaysAhead = currentDateTime.add(Duration(days: 10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.calender_ucf,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins')),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: MyTheme.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      // body: buildBody(),
      body: bodyscreen(),
    );
  }

  bodyscreen() {
    return FutureBuilder(
        future: cropsForTrackingFuture,
        builder: (context, parentSnapshot) {
          if (parentSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (parentSnapshot.hasData && parentSnapshot.data == null) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.no_crop_for_tracking,
                    style: TextStyle(
                      fontSize: 16,
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
                      AppLocalizations.of(context)!.add_crop_for_tracking,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .5,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarAddCrop()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }
          if (parentSnapshot.hasData && parentSnapshot.data != null) {
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 10,
                ),
                // crop selection
                Container(
                  // color: Colors.red,
                  // height: 110,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              parentSnapshot.data!.cropCalendarItems.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => setState(() {
                                selectedIndex = index;
                                cropDocumentForInfoFuture = getCropDocForInfo(
                                    cropName: parentSnapshot
                                        .data!
                                        .cropCalendarItems[selectedIndex!]
                                        .cropName);
                              }),
                              child: CropSelectionItemWidget(
                                image: "assets/onion.png",
                                title: parentSnapshot
                                    .data!.cropCalendarItems[index].cropName,
                                isSelected: index == selectedIndex,
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CalendarAddCrop()));
                            },
                            child: Text("Track Another Crop")),
                      ),
                    ],
                  ),
                ),

                // cost estimate, schedule, pest control, cultivation tips
                selectedIndex == null
                    ? Container(
                        height: 200,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.select_crop,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    : FutureBuilder(
                        future: cropDocumentForInfoFuture,
                        builder: (context, cropDocSnapshot) {
                          if (cropDocSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (cropDocSnapshot.hasData &&
                              cropDocSnapshot.data != null) {
                            var docData = cropDocSnapshot.data;
                            return Column(
                              children: [
                                Text(docData.toString()),

                                // cost estimate, schedule, pest control, cultivation tips
                                Container(
                                  height: 100,
                                  // color: Color(0xffC3FF77),
                                  color: MyTheme.green_lighter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 55,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  "assets/pests 1.png"),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Cost Estimate",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins"),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Tutorial()));
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 55,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  "assets/cultivation 1.png"),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Schedule",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins"),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PestControl()));
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 55,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  "assets/pests 1 (1).png"),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              "Pests Control",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins"),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CultivationTips()));
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 55,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  "assets/cultivation 1 (1).png"),
                                            ),
                                            SizedBox(height: 3),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .cultivation_tips_ucf,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins"),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                // calendar event heading
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Calender Events",
                                    style: TextStyle(
                                      color: Color(0xff107B28),
                                      // fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                // SizedBox(height: 20),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child: Container(
                                    child: ListView.builder(
                                        itemCount: 4,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return CalendarStageItem(
                                              stageName: 'hello');
                                        }),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container(
                            height: 200,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .no_data_is_available,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        }),

                SizedBox(
                  height: 40,
                ),
              ],
            );
          }
          if (parentSnapshot.hasError) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.no_crop_for_tracking,
                    style: TextStyle(
                      fontSize: 16,
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
                      AppLocalizations.of(context)!.add_crop_for_tracking,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .5,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarAddCrop()));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }
          print(parentSnapshot.hashCode);
          return Text('hello');
        });
  }

  Container CalendarStageItem({
    required String stageName,
  }) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: 1, // Space between underline and text
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color(0xff107B28),
              width: 1.0, // Underline thickness
            ))),
            child: Text(
              stageName,
              style: TextStyle(
                  //  decoration: TextDecoration.underline,
                  //   decorationThickness: 2,
                  color: Color(0xff107B28),
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: .5),
            ),
          ),
          Row(
            children: [
              Container(
                child: Text(
                  "${currentDateTime.day}/${currentDateTime.month}/${currentDateTime.year}:",
                  style: TextStyle(
                      color: MyTheme.primary_color,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins"),
                ),
              ),
              SizedBox(width: 15),
              Container(
                child: Text(
                  "Current Date",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: Text(
                  "${tenDaysAhead.day}/${tenDaysAhead.month}/${tenDaysAhead.year}:",
                  style: TextStyle(
                      color: MyTheme.primary_color,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins"),
                ),
              ),
              SizedBox(width: 15),
              Container(
                child: Text(
                  "10 days ahead",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins"),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class CropSelectionItemWidget extends StatelessWidget {
  const CropSelectionItemWidget({
    super.key,
    required this.image,
    required this.title,
    required this.isSelected,
  });

  final String image;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      width: 80,
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.black87 : Colors.black12,
          width: 3,
        ),
      ),
      // child: Image.asset(
      //   image,
      //   fit: BoxFit.cover,
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                fontFamily: 'Poppins',
              )),
        ],
      ),
    );
  }
}
