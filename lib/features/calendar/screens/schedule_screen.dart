// translation done.

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/calendar/screens/calendar_screen.dart';
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

class ScheduleScreen extends StatefulWidget {
  final String cropName;
  final String landSyno;
  final String cropId;

  const ScheduleScreen({
    Key? key,
    required this.cropName,
    required this.landSyno,
    required this.cropId,
  }) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime dateNow = DateTime.now();
  DateTime? dateOfRenting;
  late Land currentLand;
  // Land currentLand = Land()
  //   ..village = 'Village'
  //   ..syno = 'Syno'
  //   ..area = 0
  //   ..crops = []
  //   ..equipments = []
  //   ..animals = [];

  @override
  void initState() {
    super.initState();
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData == null) {
      return;
    }

    // Land newLand =
    //     savedData.land.firstWhere((element) => element.syno == widget.landSyno);
    //

    currentLand =
        savedData.land.firstWhere((element) => element.syno == widget.landSyno);

    // var dataBox = Hive.box<CropCalendarData>('cropCalendarDataBox');
    // var savedData = dataBox.get('calendar');
    // if (savedData != null) {
    //   savedData.cropCalendarItems.forEach((element) {
    //     usedIDs.add(element.id);
    //   });
    // }
    // landList = getLandList();
    // cropListFuture = getCropsList(landSyno: null);
    // super.initState();
  }

  onPressed() async {
    if (dateOfRenting == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_date,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var dataBox = Hive.box<CropCalendarData>('cropCalendarDataBox');
    var cropCalendarData = dataBox.get('calendar');

    if (cropCalendarData == null) {
      return;
    }
    int index = cropCalendarData.cropCalendarItems
        .indexWhere((item) => item.id == widget.cropId);

    // Check if the crop item with the specified ID was found
    if (index != -1) {
      // Update the planting date of the found crop item
      cropCalendarData.cropCalendarItems[index].plantingDate = dateOfRenting;

      await dataBox.put('calendar', cropCalendarData);
    }
    Navigator.pop(context);
    Navigator.pop(context);
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
          title: Text(AppLocalizations.of(context)!.schedule,
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
              await onPressed();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(MyTheme.primary_color),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0))),
            ),
            child: Text(
              AppLocalizations.of(context)!.start_tracking,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 10,
            ),
            TitleWidget(text: AppLocalizations.of(context)!.crop_details),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 200,
              margin: EdgeInsets.only(bottom: 30),
              // color: Colors.red,
              child: CachedNetworkImage(
                  imageUrl: imageForNameCloud[widget.cropName.toLowerCase()] ??
                      imageForNameCloud['placeholder']!),
            ),

            Text(
              widget.cropName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),

            SizedBox(
              height: 10,
            ),

            Text(
              currentLand.village + ' (${currentLand.syno})',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),

            SizedBox(
              height: 20,
            ),

            TitleWidget(text: AppLocalizations.of(context)!.planting_date),
            SizedBox(
              height: 10,
            ),
            // Planting Date
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () async {
                          DateTime? newData = await showDatePicker(
                              context: context,
                              initialDate: dateNow,
                              firstDate: DateTime(2000),
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
                              : AppLocalizations.of(context)!.date_ucf,
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
