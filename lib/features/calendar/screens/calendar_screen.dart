// translation done.

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/calendar/screens/calendar_add_crop.dart';
import 'package:active_ecommerce_flutter/features/calendar/screens/schedule_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/address_list.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/calender/cultivation_tip.dart';
import 'package:active_ecommerce_flutter/screens/calender/pest_control.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toast/toast.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Future<CropCalendarData?> cropsForTrackingFuture;
  late Future cropDocumentForInfoFuture;

  var imageLinks = imageForNameCloud;

  int selectedIndex = 0;

  void stopTrackingCrop(index) async {
    var dataBox = Hive.box<CropCalendarData>('cropCalendarDataBox');

    var savedData = dataBox.get('calendar');

    savedData!.cropCalendarItems.removeAt(index);

    if (savedData.cropCalendarItems.length == 0) {
      dataBox.delete('calendar');
    } else
      dataBox.put('calendar', savedData);
    setState(() {
      selectedIndex = 0;
      cropsForTrackingFuture = getCropsForTracking();
    });
  }

  Future<CropCalendarData?> getCropsForTracking() async {
    var dataBox = Hive.box<CropCalendarData>('cropCalendarDataBox');

    var savedData = dataBox.get('calendar');

    if (savedData == null) {
      return null;
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
    cropsForTrackingFuture = getCropsForTracking();
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
            cropDocumentForInfoFuture = getCropDocForInfo(
                cropName: parentSnapshot
                    .data!.cropCalendarItems[selectedIndex].cropName);
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                // crop selection
                Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              parentSnapshot.data!.cropCalendarItems.length,
                          itemBuilder: (context, index) {
                            print(parentSnapshot.data!
                                .cropCalendarItems[selectedIndex].cropName);
                            return GestureDetector(
                              onTap: () => setState(() {
                                selectedIndex = index;
                                cropDocumentForInfoFuture = getCropDocForInfo(
                                    cropName: parentSnapshot
                                        .data!
                                        .cropCalendarItems[selectedIndex]
                                        .cropName);
                              }),
                              child: CropSelectionItemWidget(
                                image: imageLinks[parentSnapshot
                                    .data!.cropCalendarItems[index].cropName
                                    .toLowerCase()],
                                title: translatedName(
                                  name: parentSnapshot
                                      .data!.cropCalendarItems[index].cropName
                                      .toLowerCase(),
                                  context: context,
                                ),
                                isSelected: index == selectedIndex,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CalendarAddCrop()));
                          },
                          child: ClipRRect(
                            child: Image.asset(
                              "assets/add 2.png",
                              height: 50,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // cost estimate, schedule, pest control, cultivation tips
                FutureBuilder(
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
                        var currentCrop = parentSnapshot
                            .data!.cropCalendarItems[selectedIndex];
                        return Column(
                          children: [
                            // Text(docData['stages'].toString()),

                            // cost estimate, schedule, pest control, cultivation tips
                            Container(
                              height: 100,
                              // color: Color(0xffC3FF77),
                              color: MyTheme.green_lighter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // cost esmite
                                  InkWell(
                                    onTap: docData['costEstimate'] == null ||
                                            docData['costEstimate'] == ''
                                        ? () {
                                            ToastComponent.showDialog(
                                                AppLocalizations.of(context)!
                                                    .cost_estimate_hasnt_been_added_yet,
                                                gravity: Toast.center,
                                                duration: Toast.lengthLong);
                                            return;
                                          }
                                        : () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 10,
                                                            left: 10,
                                                            right: 10),
                                                    // actionsPadding: EdgeInsets.all(0),
                                                    content: Container(
                                                      height: 300,
                                                      child: CachedNetworkImage(
                                                        imageUrl: docData[
                                                            'costEstimate'],
                                                        fit: BoxFit.fitWidth,
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                progress) {
                                                          return Center(
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .dismiss)),
                                                    ],
                                                  );
                                                });
                                          },
                                    child: Container(
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
                                                    BorderRadius.circular(10)),
                                            child: Image.asset(
                                                "assets/pests 1.png"),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .cost_estimate,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),

                                  // schedule
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ScheduleScreen(
                                            cropName: currentCrop.cropName,
                                            landSyno: currentCrop.landSyno,
                                            cropId: currentCrop.id,
                                          ),
                                        ),
                                      );
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
                                                  BorderRadius.circular(10)),
                                          child: Image.asset(
                                              "assets/cultivation 1.png"),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .schedule,
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
                                                  BorderRadius.circular(10)),
                                          child: Image.asset(
                                              "assets/pests 1 (1).png"),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .pest_control,
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
                                                  BorderRadius.circular(10)),
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

                            currentCrop.plantingDate == null
                                ? Container(
                                    height: 200,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .add_date_for_tracking_by_going_to_schedule_section,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .calendar_events,
                                          style: TextStyle(
                                            color: Color(0xff107B28),
                                            // fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),

                                      // SizedBox(height: 20),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .planting_date,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Poppins"),
                                              ),
                                              Text(
                                                ': ${currentCrop.plantingDate!.day}/${currentCrop.plantingDate!.month}/${currentCrop.plantingDate!.year}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20),
                                        child: Container(
                                          child: ListView.builder(
                                            itemCount: docData['stages'].length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return CalendarStageItem(
                                                stageName:
                                                    '${AppLocalizations.of(context)!.stage_for_calendar} ${index + 1}',
                                                stage1text: docData['stages']
                                                    [index]['0']['name'],
                                                stage2text: docData['stages']
                                                    [index]['1']['name'],
                                                initialDate: currentCrop
                                                    .plantingDate!
                                                    .add(Duration(
                                                        days: docData['stages']
                                                                [index]['0']
                                                            ['days'])),
                                                stage1days: docData['stages']
                                                    [index]['0']['days'],
                                                stage2days: docData['stages']
                                                    [index]['1']['days'],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        );
                      }
                      return Container(
                        height: 200,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.no_data_is_available,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }),

                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          // backgroundColor: MyTheme.accent_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.grey[200]!,
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        onPressed: () {
                          stopTrackingCrop(selectedIndex);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.stop_tracking,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .5,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )),
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
        });
  }

  Container CalendarStageItem({
    required String stageName,
    required String stage1text,
    required String stage2text,
    required DateTime initialDate,
    required int stage1days,
    required int stage2days,
  }) {
    DateTime stage1Date = initialDate.add(Duration(days: stage1days));
    DateTime stage2Date = stage1Date.add(Duration(days: stage2days));
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
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                child: Text(
                  "${stage1Date.day}/${stage1Date.month}/${stage1Date.year}:",
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
                  stage1text,
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
                  "${stage2Date.day}/${stage2Date.month}/${stage2Date.year}:",
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
                  stage2text,
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

  final String? image;
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: image == null
                  ? Image.asset(
                      "assets/placeholder.png",
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: image!,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) => Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
