// translation done.

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/checkout_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_bloc/rent_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_bloc/rent_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_bloc/rent_state.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../../../custom/device_info.dart';

import 'package:time_range_picker/time_range_picker.dart';

// import '../seller_platform/seller_platform.dart';

class MachineRentForm extends StatefulWidget {
  final String machineId;
  final List imageURL;
  final String machineName;
  final double machinePrice;
  final String machineDescription;
  final String sellerId;

  const MachineRentForm({
    Key? key,
    required this.machineId,
    required this.imageURL,
    required this.machineName,
    required this.machinePrice,
    required this.machineDescription,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<MachineRentForm> createState() => _MachineRentFormState();
}

class _MachineRentFormState extends State<MachineRentForm> {
  DateTime dateNow = DateTime.now();
  DateTime? dateOfRenting;

  TimeRange? timeRangeOfRenting;

  String? landDropdownValue;
  // String? pinCodeOfLand;
  String? locationNameOfLand;
  late Future<List<Land>> landList;
  late Future productDocForSlotsFuture;

  String? hour12FormarTimeSlot;

  List splitTimeRange(String timeRange) {
    List<String> timeSlots = [];

    var parts = timeRange.split(' - ');

    // Convert input strings to DateTime objects
    final dateFormat = DateFormat('HH:mm');

    DateTime startDateTime = dateFormat.parse(parts[0]);
    DateTime endDateTime = dateFormat.parse(parts[1]);

    while (startDateTime.isBefore(endDateTime)) {
      String slotStart = dateFormat.format(startDateTime);

      startDateTime = startDateTime.add(Duration(minutes: 30));

      String slotEnd = dateFormat.format(startDateTime);

      timeSlots.add('$slotStart - $slotEnd');
    }

    return timeSlots;
  }

  @override
  void initState() {
    super.initState();
    landList = getLandList();
    productDocForSlotsFuture = getProductDocForSlots(date: null);
  }

  Future<List<Land>> getLandList() async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData == null) {
      throw Exception('Failed to load data');
    }

    return savedData.land;
  }

  Future getProductDocForSlots({required String? date}) async {
    if (date == null) {
      return null;
    }
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.machineId)
        .get();

    if (userSnapshot.exists) {
      return [userSnapshot.data(), date];
    } else {
      return null;
    }
  }

  getTimeRangeString(TimeRange timeRange) {
    var time = timeRange.startTime;
    var endTime = timeRange.endTime;
    return 'range: ${time.hour}:${time.minute}-${endTime.hour}:${endTime.minute}';
  }

  String getVillageFromSyno(List<Land> lands, String targetSyno) {
    for (Land land in lands) {
      if (land.syno == targetSyno) {
        return land.village;
      }
    }
    // Return a default value or handle the case where the syno is not found
    return 'Syno not found';
  }

  String convert12HourTo24Hour(String inputTime) {
    List<String> timeParts = inputTime.split(' - ');

    String startTime = _convertSingle12HourTo24Hour(timeParts[0]);
    String endTime = _convertSingle12HourTo24Hour(timeParts[1]);

    return '$startTime - $endTime';
  }

  String _convertSingle12HourTo24Hour(String time) {
    // Extracting hours, minutes, and period from the input time
    RegExp timeRegex = RegExp(r'(\d+):(\d+)\s?([apAP][mM])');
    Match match = timeRegex.firstMatch(time) as Match;

    // ignore: unnecessary_null_comparison
    if (match != null) {
      int hours = int.parse(match.group(1)!);
      int minutes = int.parse(match.group(2)!);
      String period = match.group(3)!.toLowerCase();

      // Adjusting hours based on the period (AM/PM)
      if (period == 'pm' && hours < 12) {
        hours += 12;
      } else if (period == 'am' && hours == 12) {
        hours = 0;
      }

      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }

    // Return the original time if the regex doesn't match
    return time;
  }

  bool hasCommonElement(List<dynamic> list1, List<dynamic> list2) {
    return list1.any((element) => list2.contains(element));
  }

  String convertTimeRangeTo12Hour(String timeRange24) {
    final List<String> times = timeRange24.split(' - ');

    final DateFormat formatter = DateFormat('HH:mm');
    final DateTime startTime = formatter.parse(times[0].trim());
    final DateTime endTime = formatter.parse(times[1].trim());

    final String formattedStartTime = DateFormat('h:mma').format(startTime);
    final String formattedEndTime = DateFormat('h:mma').format(endTime);

    return '$formattedStartTime-$formattedEndTime';
  }

  onPressedBook(BuildContext buildContext) async {
    if (dateOfRenting == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_date,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (timeRangeOfRenting == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_time,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (landDropdownValue == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_land,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var documentData;
    List? alreadyBookedSlotsBroken = [];

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.machineId)
        .get();
    documentData = userSnapshot.data();
    alreadyBookedSlotsBroken = documentData['bookedSlotsBroken']?[
        dateOfRenting!.day.toString() +
            '-' +
            dateOfRenting!.month.toString() +
            '-' +
            dateOfRenting!.year.toString()];

    // print(alreadyBookedSlotsBroken);

    // return;

    var hour24format =
        '${timeRangeOfRenting!.startTime.hour}:${timeRangeOfRenting!.startTime.minute == 0 ? '00' : timeRangeOfRenting!.startTime.minute} - ${timeRangeOfRenting!.endTime.hour}:${timeRangeOfRenting!.endTime.minute == 0 ? '00' : timeRangeOfRenting!.endTime.minute}';

    var checkerBookedSlotsBroken = splitTimeRange(hour24format);
    print(hour24format);
    print(checkerBookedSlotsBroken);

    if (alreadyBookedSlotsBroken == null ||
        alreadyBookedSlotsBroken.length == 0) {
      alreadyBookedSlotsBroken = [];
    }
    if (hasCommonElement(alreadyBookedSlotsBroken, checkerBookedSlotsBroken)) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.recheck_slot_and_try_again,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.machineId)
        .update(
      {
        'bookedSlots.${dateOfRenting!.day}-${dateOfRenting!.month}-${dateOfRenting!.year}':
            FieldValue.arrayUnion([hour24format]),
        'bookedSlotsBroken.${dateOfRenting!.day}-${dateOfRenting!.month}-${dateOfRenting!.year}':
            FieldValue.arrayUnion(splitTimeRange(hour24format)),
      },
    );

    BlocProvider.of<RentBloc>(buildContext).add(
      RentProductRequested(
        bookedDate:
            '${dateOfRenting!.day}-${dateOfRenting!.month}-${dateOfRenting!.year}',
        sellerId: widget.sellerId,
        bookedSlot: hour24format,
        locationName: locationNameOfLand!,
        orderItems: [
          OrderItem(
            productID: widget.machineId,
            price: widget.machinePrice,
            quantity: 1,
            sellerID: widget.sellerId,
            rating: 0,
          ),
        ],
        numberOfHalfHours: checkerBookedSlotsBroken.length,
      ),
    );

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay? rentStartTime = timeRangeOfRenting?.startTime;
    TimeOfDay? rentEndTime = timeRangeOfRenting?.endTime;
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff107B28), Color(0xff4C7B10)]),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.rent_a_machine,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins'),
          ),
          centerTitle: true,
        ),
        bottomSheet: Container(
          height: 60,
          width: double.infinity,
          child: BlocListener<RentBloc, RentState>(
            listener: (context, state) {
              if (state is RentSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                            orderID: state.documentId,
                          )),
                );
              }
            },
            child: BlocBuilder<RentBloc, RentState>(
              builder: (context, state) {
                if (state is RentLoading) {
                  return ElevatedButton(
                    onPressed: () async {
                      // onPressedBook(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MyTheme.primary_color),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                return ElevatedButton(
                  onPressed: () async {
                    onPressedBook(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyTheme.primary_color),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0))),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.book,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 1), () {
              setState(() {
                productDocForSlotsFuture = getProductDocForSlots(
                    date:
                        '${dateOfRenting!.day}-${dateOfRenting!.month}-${dateOfRenting!.year}');
              });
            });
          },
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 10,
              ),

              TitleWidget(text: AppLocalizations.of(context)!.machine),

              SizedBox(
                height: 10,
              ),

              // Machine
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Machine Image
                      Container(
                        height: 250,
                        color: Colors.grey[200],
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: double.infinity,
                            aspectRatio: 1 / 1.5,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            autoPlay: false,
                            padEnds: false,
                          ),
                          items: widget.imageURL.map((fileURL) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      fileURL,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Machine Price
                      Container(
                        padding: EdgeInsets.only(
                            left: 18, right: 18, bottom: 12, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.machineName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '\₹${widget.machinePrice}/30 mins',
                              // locale: Locale.fromSubtags(languageCode: 'en'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.machineDescription,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  height: 1.2,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),
              TitleWidget(text: AppLocalizations.of(context)!.planning_date),

              SizedBox(
                height: 5,
              ),

              // Planning Date
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
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                                productDocForSlotsFuture = getProductDocForSlots(
                                    date:
                                        '${dateOfRenting!.day}-${dateOfRenting!.month}-${dateOfRenting!.year}');
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
                                          color: Colors.transparent,
                                          width: 0))),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 255, 172, 200))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  AppLocalizations.of(context)!.already_booked_slots,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FutureBuilder(
                    future: productDocForSlotsFuture,
                    builder: (context, slotSnapshot) {
                      if (slotSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          // height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      // if (slotSnapshot.hasData && slotSnapshot.data == null) {
                      //   return Center(
                      //     child: Text('No slots booked'),
                      //   );
                      // }
                      if (slotSnapshot.hasData && slotSnapshot.data != null) {
                        List? bookedSlots = slotSnapshot.data[0]['bookedSlots']
                            ?[slotSnapshot.data[1]];

                        return bookedSlots == null || bookedSlots.length == 0
                            ? Container(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .no_slot_booked,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            : Wrap(
                                children: List.generate(
                                    bookedSlots.length,
                                    (index) => Chip(
                                          labelPadding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          label: Text(
                                            convertTimeRangeTo12Hour(
                                                bookedSlots[index]),
                                            style: TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        )).toList(),
                              );
                      }
                      return Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.select_date,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
              ),

              SizedBox(
                height: 5,
              ),

              Container(
                height: 60,
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    TimeRange result = await showTimeRangePicker(
                      disabledTime: TimeRange(
                          startTime: TimeOfDay(hour: 20, minute: 0),
                          endTime: TimeOfDay(hour: 8, minute: 0)),
                      context: context,
                      start: const TimeOfDay(hour: 10, minute: 0),
                      interval: const Duration(minutes: 30),
                      minDuration: const Duration(minutes: 30),
                      use24HourFormat: false,
                      padding: 30,
                      strokeWidth: 12,
                      handlerRadius: 9,
                      strokeColor: MyTheme.primary_color,
                      handlerColor: MyTheme.green_light,
                      selectedColor: MyTheme.primary_color,
                      backgroundColor: Colors.black.withOpacity(0.3),
                      ticks: 12,
                      ticksColor: Colors.white,
                      snap: true,
                      labels: [
                        "12 am",
                        "3 am",
                        "6 am",
                        "9 am",
                        "12 pm",
                        "3 pm",
                        "6 pm",
                        "9 pm"
                      ].asMap().entries.map((e) {
                        return ClockLabel.fromIndex(
                            idx: e.key, length: 8, text: e.value);
                      }).toList(),
                      labelOffset: -30,
                      labelStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                      timeTextStyle: TextStyle(
                          color: MyTheme.primary_color,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                      activeTimeTextStyle: TextStyle(
                          color: MyTheme.primary_color,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    );

                    print("result " + result.toString());

                    setState(() {
                      timeRangeOfRenting = result;
                      // hour12FormarTimeSlot =
                      //     '${rentStartTime!.hourOfPeriod}:${rentStartTime.minute == 0 ? '00' : rentStartTime.minute} ${rentStartTime.period.name} - ${rentEndTime!.hourOfPeriod}:${rentEndTime.minute == 0 ? '00' : rentEndTime.minute} ${rentEndTime.period.name}';
                    });
                  },
                  child: Text(
                    timeRangeOfRenting != null
                        ? '${rentStartTime!.hourOfPeriod}:${rentStartTime.minute == 0 ? '00' : rentStartTime.minute} ${rentStartTime.period.name} - ${rentEndTime!.hourOfPeriod}:${rentEndTime.minute == 0 ? '00' : rentEndTime.minute} ${rentEndTime.period.name}'
                        : AppLocalizations.of(context)!.time,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: Colors.transparent, width: 0))),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 243, 131))),
                ),
              ),

              SizedBox(
                height: 15,
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButtonWidget(
                          hintText: AppLocalizations.of(context)!.select_land,
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
                                            child: Text(
                                                snapshot.data![index].syno)),
                                      ],
                                    ),
                                  )).toList(),
                          dropdownValue: landDropdownValue,
                          onChanged: (value) {
                            setState(() {
                              landDropdownValue = value;
                              locationNameOfLand = getVillageFromSyno(
                                  snapshot.data!, landDropdownValue!);
                            });
                          },
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),

              Container(
                height: 65,
              ),
            ],
          ),
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

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.green_lighter,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
