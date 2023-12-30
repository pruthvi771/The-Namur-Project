// translation done.

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/calendar/screens/calendar_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/address_list.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/machine_rent_form.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import '../../../custom/device_info.dart';
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

  int? selectedIndex;
  String? selectedCropName;
  String? idOfCrop;

  List<String> usedIDs = [];

  @override
  void initState() {
    var dataBox = Hive.box<CropCalendarData>('cropCalendarDataBox');
    var savedData = dataBox.get('calendar');
    if (savedData != null) {
      savedData.cropCalendarItems.forEach((element) {
        usedIDs.add(element.id);
      });
    }
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

  Future<void> onPressedAdd() async {
    if (landDropdownValue == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_land,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (selectedCropName == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_crop,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    // if (dateOfRenting == null) {
    //   ToastComponent.showDialog(AppLocalizations.of(context)!.select_date,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // }

    var dataBox = Hive.box<CropCalendarData>('cropCalendarDataBox');
    var savedData = dataBox.get('calendar');

    var cropCalendarItem = CropCalendarItem()
      ..cropName = selectedCropName!
      ..landSyno = landDropdownValue!
      ..id = idOfCrop!
      ..plantingDate = null;

    if (savedData == null) {
      var newData = CropCalendarData()..cropCalendarItems = [cropCalendarItem];
      await dataBox.put('calendar', newData);
    } else {
      savedData.cropCalendarItems.forEach((element) {
        usedIDs.add(element.id);
      });
      if (usedIDs.contains(cropCalendarItem.id)) {
        ToastComponent.showDialog(
            AppLocalizations.of(context)!.crop_already_added,
            gravity: Toast.center,
            duration: Toast.lengthLong);
        return;
      }
      var newData = CropCalendarData()
        ..cropCalendarItems = [
          ...savedData.cropCalendarItems,
          cropCalendarItem
        ];
      await dataBox.put('calendar', newData);
    }

    print(landDropdownValue);
    print(selectedCropName);
    print(dateOfRenting);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CalendarScreen()));
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
              await onPressedAdd();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(MyTheme.primary_color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
            ),
            child: Text(
              AppLocalizations.of(context)!.add_crop_for_tracking,
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

            TitleWidget(text: AppLocalizations.of(context)!.land),

            SizedBox(
              height: 20,
            ),

            // Select Land
            FutureBuilder(
                future: landList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.length == 0
                        ? Container(
                            height: 100,
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.no_land_added_yet,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            )),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButtonWidget(
                              hintText:
                                  AppLocalizations.of(context)!.select_land,
                              itemList: List.generate(
                                  snapshot.data!.length,
                                  (index) => DropdownMenuItem<String>(
                                        value: snapshot.data![index].syno,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text(snapshot
                                                    .data![index].village)),
                                            Expanded(
                                                child: Text(snapshot
                                                    .data![index].syno)),
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
                                // print(landDropdownValue);
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

            TitleWidget(text: AppLocalizations.of(context)!.crop_selection),

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
                  } else if (cropSnapshot.hasData &&
                      cropSnapshot.data != null) {
                    List<Crop> cropList = cropSnapshot.data!;
                    return cropList.length == 0
                        ? Container(
                            height: 100,
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!
                                  .no_crops_added_for_this_land,
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
                                // return usedIDs.contains(cropList[index].id)
                                //     ? SizedBox.shrink()
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      selectedCropName = cropList[index].name;
                                      idOfCrop = cropList[index].id;
                                    });
                                  },
                                  child: EquipmentWidget(
                                    image: imageForNameCloud[cropList[index]
                                            .name
                                            .toLowerCase()] ??
                                        imageForNameCloud['placeholder']!,
                                    title: translatedName(
                                      name: cropList[index].name.toLowerCase(),
                                      context: context,
                                    ),
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
                      AppLocalizations.of(context)!.select_land_to_see_crops,
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

            // TitleWidget(text: AppLocalizations.of(context)!.planting_date),

            // // Planting Date
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 4),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Container(
            //           height: 60,
            //           padding: EdgeInsets.all(8),
            //           child: ElevatedButton(
            //             onPressed: () async {
            //               DateTime? newData = await showDatePicker(
            //                   context: context,
            //                   initialDate: dateNow,
            //                   firstDate: DateTime(2000),
            //                   lastDate: DateTime(2025));
            //               if (newData != null) {
            //                 setState(() {
            //                   dateOfRenting = newData;
            //                 });
            //               }
            //             },
            //             child: Text(
            //               dateOfRenting != null
            //                   ? '${dateOfRenting!.day}/${dateOfRenting!.month}/${dateOfRenting!.year}'
            //                   : AppLocalizations.of(context)!.date_ucf,
            //               style: TextStyle(
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w800,
            //                 fontSize: 15,
            //               ),
            //             ),
            //             style: ButtonStyle(
            //                 elevation: MaterialStateProperty.all(0),
            //                 shape: MaterialStateProperty.all<
            //                         RoundedRectangleBorder>(
            //                     RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(12),
            //                         side: BorderSide(
            //                             color: Colors.transparent, width: 0))),
            //                 backgroundColor: MaterialStateProperty.all(
            //                     const Color.fromARGB(255, 255, 243, 131))),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

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
            child: CachedNetworkImage(
              imageUrl: image,
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
