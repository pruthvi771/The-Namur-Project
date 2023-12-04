import 'package:active_ecommerce_flutter/features/calendar/screens/calendar_screen.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/machine_rent_form.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import '../../../custom/device_info.dart';
import 'package:active_ecommerce_flutter/features/profile/address_list.dart'
    as addressList;

import 'package:time_range_picker/time_range_picker.dart';

class CalendarAddCrop extends StatefulWidget {
  const CalendarAddCrop({Key? key}) : super(key: key);

  @override
  State<CalendarAddCrop> createState() => _CalendarAddCropState();
}

class _CalendarAddCropState extends State<CalendarAddCrop> {
  DateTime dateNow = DateTime.now();
  DateTime? dateOfRenting;

  TimeRange? timeRangeOfRenting;

  String? landDropdownValue;
  late Future<List<Land>> landList;
  late Future<List<Crop>?> cropListFuture;

  final imageForCrop = addressList.imageForCrop;

  int selectedIndex = 0;

  @override
  void initState() {
    landList = getLandList();
    cropListFuture = getCropsList(landSyno: null);
    super.initState();
  }

  Future<List<Land>> getLandList() async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData == null) {
      throw Exception('Failed to load data');
    }

    return savedData.land;
  }

  Future<List<Crop>?> getCropsList({required String? landSyno}) async {
    // await Future.delayed(const Duration(seconds: 5));
    // List<Crop> cropList = [];
    if (landSyno == null) {
      return null;
    }
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData == null) {
      throw Exception('Failed to load data');
    }

    return savedData.land
        .firstWhere((element) => element.syno == landSyno)
        .crops;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        bottomSheet: Container(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CalendarScreen()));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(MyTheme.primary_color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
            ),
            child: Text(
              'Add Crop for Tracking',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 10,
            ),

            TitleWidget(text: 'Land'),

            SizedBox(
              height: 20,
            ),

            // Select Land
            FutureBuilder(
                future: landList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButtonWidget(
                        hintText: 'Select Land',
                        itemList: List.generate(
                            snapshot.data!.length,
                            (index) => DropdownMenuItem<String>(
                                  value: snapshot.data![index].syno,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              snapshot.data![index].village)),
                                      Expanded(
                                          child:
                                              Text(snapshot.data![index].syno)),
                                    ],
                                  ),
                                )).toList(),
                        dropdownValue: landDropdownValue,
                        onChanged: (value) {
                          setState(() {
                            landDropdownValue = value;
                            cropListFuture =
                                getCropsList(landSyno: landDropdownValue);
                          });
                          print(landDropdownValue);
                        },
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),

            SizedBox(
              height: 10,
            ),

            TitleWidget(text: 'Crop Selection'),

            SizedBox(
              height: 15,
            ),

            FutureBuilder(
                future: cropListFuture,
                builder: (context, cropSnapshot) {
                  if (cropSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                    // } else if (cropSnapshot.hasError) {
                    //   return Text('Error: ${cropSnapshot.error}');
                  } else if (cropSnapshot.hasData &&
                      cropSnapshot.data != null) {
                    print(cropSnapshot.data);
                    // return Center(child: Text('has data '));
                    List<Crop> cropList = cropSnapshot.data!;
                    return cropList.length == 0
                        ? Container(
                            height: 100,
                            child: Center(
                                child: Text(
                              'No crops added for this land yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            )),
                          )
                        : Container(
                            height: 140,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: cropList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: EquipmentWidget(
                                    image: imageForCrop[cropList[index].name]!,
                                    title: cropList[index].name,
                                    isSelected: selectedIndex == index,
                                  ),
                                );
                              },
                            ),
                          );
                  }
                  return Container(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Select Land to see crops',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    )),
                  );
                }),

            SizedBox(
              height: 15,
            ),

            // Machine
            // Padding(
            //   padding: const EdgeInsets.all(6.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.grey[100],
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         // Machine Image
            //         // Container(
            //         //   height: 250,
            //         //   color: Colors.grey[200],
            //         //   padding:
            //         //       EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //         //   child: CarouselSlider(
            //         //     options: CarouselOptions(
            //         //       viewportFraction: 1,
            //         //       height: double.infinity,
            //         //       aspectRatio: 1 / 1.5,
            //         //       enlargeCenterPage: true,
            //         //       enableInfiniteScroll: false,
            //         //       autoPlay: false,
            //         //       padEnds: false,
            //         //     ),
            //         //     items: widget.imageURL.map((fileURL) {
            //         //       return Builder(
            //         //         builder: (BuildContext context) {
            //         //           return Container(
            //         //             child: ClipRRect(
            //         //               borderRadius: BorderRadius.all(
            //         //                 Radius.circular(10),
            //         //               ),
            //         //               child: Image.network(
            //         //                 fileURL,
            //         //                 fit: BoxFit.cover,
            //         //                 width: MediaQuery.of(context).size.width,
            //         //               ),
            //         //             ),
            //         //           );
            //         //         },
            //         //       );
            //         //     }).toList(),
            //         //   ),
            //         // ),
            //         SizedBox(
            //           height: 10,
            //         ),
            //         // Machine Price
            //         Container(
            //           padding: EdgeInsets.only(
            //               left: 18, right: 18, bottom: 12, top: 5),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'widget.machineName',
            //                 style: TextStyle(
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.w900,
            //                   color: Colors.black,
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 10,
            //               ),
            //               Text(
            //                 '\₹{widget.machinePrice/30 mins',
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w900,
            //                   color: Colors.grey[700],
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 8,
            //               ),
            //               Container(
            //                 // padding: const EdgeInsets.all(8.0),
            //                 child: Text(
            //                   'widget.machineDescription',
            //                   style: TextStyle(
            //                     fontSize: 13.5,
            //                     height: 1.2,
            //                     fontWeight: FontWeight.w500,
            //                     color: Colors.black,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            SizedBox(
              height: 20,
            ),
            TitleWidget(text: 'Planting Date'),

            SizedBox(
              height: 10,
            ),

            // Planting Date
            Container(
              // height: 50,
              // color: Colors.amber,
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    // flex: 4,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          DateTime? newData = await showDatePicker(
                              context: context,
                              initialDate: dateNow,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025));

                          if (newData != null) {
                            setState(() {
                              dateOfRenting = newData;
                            });
                          }
                        },
                        child: Text(
                          dateOfRenting != null
                              ? '${dateOfRenting!.day}/${dateOfRenting!.month}/${dateOfRenting!.year}'
                              : 'Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                        color: Colors.transparent, width: 0))),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 255, 243, 131))),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 6,
                  //   child: Container(
                  //     height: 60,
                  //     padding: EdgeInsets.all(8),
                  //     child: ElevatedButton(
                  //       onPressed: () async {
                  //         TimeRange result = await showTimeRangePicker(
                  //           context: context,
                  //           start: const TimeOfDay(hour: 22, minute: 9),
                  //           interval: const Duration(minutes: 30),
                  //           minDuration: const Duration(minutes: 30),
                  //           use24HourFormat: false,
                  //           padding: 30,
                  //           strokeWidth: 12,
                  //           handlerRadius: 9,
                  //           strokeColor: MyTheme.primary_color,
                  //           handlerColor: MyTheme.green_light,
                  //           selectedColor: MyTheme.primary_color,
                  //           backgroundColor: Colors.black.withOpacity(0.3),
                  //           ticks: 12,
                  //           ticksColor: Colors.white,
                  //           snap: true,
                  //           labels: [
                  //             "12 am",
                  //             "3 am",
                  //             "6 am",
                  //             "9 am",
                  //             "12 pm",
                  //             "3 pm",
                  //             "6 pm",
                  //             "9 pm"
                  //           ].asMap().entries.map((e) {
                  //             return ClockLabel.fromIndex(
                  //                 idx: e.key, length: 8, text: e.value);
                  //           }).toList(),
                  //           labelOffset: -30,
                  //           labelStyle: const TextStyle(
                  //               fontSize: 15,
                  //               color: Colors.grey,
                  //               fontWeight: FontWeight.bold),
                  //           timeTextStyle: TextStyle(
                  //               color: MyTheme.primary_color,
                  //               fontSize: 24,
                  //               fontWeight: FontWeight.w900),
                  //           activeTimeTextStyle: TextStyle(
                  //               color: MyTheme.primary_color,
                  //               fontSize: 26,
                  //               fontWeight: FontWeight.bold),
                  //         );
                  //         print("result " + result.toString());
                  //         setState(() {
                  //           timeRangeOfRenting = result;
                  //         });
                  //       },
                  //       child: Text(
                  //         timeRangeOfRenting != null
                  //             ? '${rentStartTime!.hourOfPeriod}:${rentStartTime.minute == 0 ? '00' : rentStartTime.minute} ${rentStartTime.period.name} - ${rentEndTime!.hourOfPeriod}:${rentEndTime.minute == 0 ? '00' : rentEndTime.minute} ${rentEndTime.period.name}'
                  //             : 'Time',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.w800,
                  //           fontSize: 15,
                  //         ),
                  //       ),
                  //       style: ButtonStyle(
                  //           elevation: MaterialStateProperty.all(0),
                  //           shape: MaterialStateProperty.all<
                  //                   RoundedRectangleBorder>(
                  //               RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(12),
                  //                   side: BorderSide(
                  //                       color: Colors.transparent, width: 0))),
                  //           backgroundColor: MaterialStateProperty.all(
                  //               const Color.fromARGB(255, 255, 243, 131))),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            Container(
              height: 65,
            ),
          ],
        ),
      ),
    );
  }

  Column DropdownButtonWidget(
      {required String hintText,
      required List<DropdownMenuItem<String>>? itemList,
      required String? dropdownValue,
      required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey, // You can customize the border color here
            ),
          ),
          child: DropdownButton<String>(
            hint: Text(
              hintText,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            underline: SizedBox(), // Remove the underline
            style: TextStyle(
              fontSize: 16,
              color: Colors.black, // You can customize the text color here
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              onChanged(value!);
            },
            // items: itemList.map<DropdownMenuItem<String>>((String value) {
            //   return DropdownMenuItem<String>(
            //     value: value,
            //     child: Text(value),
            //   );
            // }).toList(),
            items: itemList,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class EquipmentWidget extends StatelessWidget {
  const EquipmentWidget({
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
      height: 120,
      width: 90,
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              image,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                fontFamily: 'Poppins',
              )),
        ],
      ),
    );
  }
}
