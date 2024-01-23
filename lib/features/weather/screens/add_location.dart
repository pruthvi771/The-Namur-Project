// translation done.

import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_event.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_bloc.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_event.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';

import 'package:active_ecommerce_flutter/features/profile/address_list.dart'
    as addressList;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddWeatherLocation extends StatefulWidget {
  AddWeatherLocation({
    Key? key,
    this.isPrimaryLocation = false,
  }) : super(key: key);

  final bool isPrimaryLocation;

  @override
  State<AddWeatherLocation> createState() => _AddWeatherLocationState();
}

class _AddWeatherLocationState extends State<AddWeatherLocation> {
  final districts = addressList.districtListForWeather;
  String districtDropdownValue = addressList.districtListForWeather[0];
  // String talukDropdownValue = addressList.districtTalukMap[1][0] as String;

  void initState() {
    super.initState();
    BlocProvider.of<HiveBloc>(context).add(
      HiveLocationDataRequested(),
    );
  }

  Future<void> addPrimaryLocationToHive() async {
    var dataBox = Hive.box<hiveModels.PrimaryLocation>('primaryLocationBox');

    var savedData = dataBox.get('locationData');

    var primaryLocation = hiveModels.PrimaryLocation()
      ..id = "locationData"
      ..isAddress = true
      ..latitude = 0.0
      ..longitude = 0.0
      ..address = districtDropdownValue;

    await dataBox.put(primaryLocation.id, primaryLocation);

    // BlocProvider.of<HiveBloc>(context).add(
    //   HiveLocationDataRequested(),
    // );
    BlocProvider.of<WeatherBloc>(context).add(
      WeatherSreenDataRequested(),
    );
    BlocProvider.of<WeatherSectionBloc>(context).add(
      WeatherSectionDataRequested(),
    );
    Navigator.pop(context);
  }

  Future<void> deleteSecondaryLocationFromHive(index) async {
    var SecondaryDataBox =
        Hive.box<hiveModels.SecondaryLocations>('secondaryLocationsBox');

    var savedData = SecondaryDataBox.get('secondaryLocations');

    savedData!.address.removeAt(index);

    var newData = hiveModels.SecondaryLocations()
      ..id = "secondaryLocations"
      ..address = [...savedData.address];

    await SecondaryDataBox.put(newData.id, newData);

    BlocProvider.of<HiveBloc>(context).add(
      HiveLocationDataRequested(),
      // HiveAppendAddress(context: context),
    );
    BlocProvider.of<WeatherBloc>(context).add(
      WeatherSreenDataRequested(),
    );
    BlocProvider.of<WeatherSectionBloc>(context).add(
      WeatherSectionDataRequested(),
    );
  }

  Future<void> addLocationToHive() async {
    if (districtDropdownValue == '') {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_a_location,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var primaryDataBox =
        Hive.box<hiveModels.PrimaryLocation>('primaryLocationBox');

    var savedPrimaryData = primaryDataBox.get('locationData');

    if (savedPrimaryData != null) {
      if (savedPrimaryData.address == districtDropdownValue) {
        ToastComponent.showDialog(
            AppLocalizations.of(context)!.location_is_already_added,
            gravity: Toast.center,
            duration: Toast.lengthLong);
        return;
      }
    }
    // savedPrimaryData.isAddress = true;

    var SecondaryDataBox =
        Hive.box<hiveModels.SecondaryLocations>('secondaryLocationsBox');

    var savedData = SecondaryDataBox.get('secondaryLocations');

    if (savedData != null) {
      if (savedData.address.length == 2) {
        ToastComponent.showDialog(
            AppLocalizations.of(context)!.can_add_only_two_location,
            gravity: Toast.center,
            duration: Toast.lengthLong);
        return;
      }
    }

    var secondaryLocations;

    if (savedData == null) {
      secondaryLocations = hiveModels.SecondaryLocations()
        ..id = "secondaryLocations"
        ..address = [districtDropdownValue];
    } else {
      if (savedData.address.contains(districtDropdownValue)) {
        ToastComponent.showDialog(
            AppLocalizations.of(context)!.location_is_already_added,
            gravity: Toast.center,
            duration: Toast.lengthLong);
        return;
      }
      secondaryLocations = hiveModels.SecondaryLocations()
        ..id = "secondaryLocations"
        ..address = [...savedData.address, districtDropdownValue];
    }

    await SecondaryDataBox.put(secondaryLocations.id, secondaryLocations);

    BlocProvider.of<HiveBloc>(context).add(
      HiveLocationDataRequested(),
      // HiveAppendAddress(context: context),
    );
    BlocProvider.of<WeatherBloc>(context).add(
      WeatherSreenDataRequested(),
    );
    BlocProvider.of<WeatherSectionBloc>(context).add(
      WeatherSectionDataRequested(),
    );
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
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.select_location_for_weather,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: MyTheme.dark_font_grey,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            BlocListener<HiveBloc, HiveState>(
              listener: (context, state) {
                if (state is Error) {}
                if (state is HiveLocationDataReceived) {}
              },
              child:
                  BlocBuilder<HiveBloc, HiveState>(builder: (context, state) {
                if (state is Loading)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (state is HiveLocationDataReceived)
                  return Column(
                    children: List.generate(
                      state.locationData.length,
                      (index) {
                        var item = state.locationData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyTheme.green_lighter,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(item)),
                                InkWell(
                                  onTap: () async {
                                    await deleteSecondaryLocationFromHive(
                                      index,
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: MyTheme.green,
                                    child: Icon(
                                      Icons.delete,
                                      size: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                return Text('error');
              }),
            ),
            SizedBox(
              height: 15,
            ),
            DropdownButtonWidget(
                AppLocalizations.of(context)!.select,
                districts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                districtDropdownValue, (value) {
              setState(() {
                districtDropdownValue = value;
                setState(() {});
              });
            }),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: SizedBox.shrink()),
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
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .5,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    onPressed: () async {
                      //
                      if (widget.isPrimaryLocation) {
                        await addPrimaryLocationToHive();
                      } else {
                        await addLocationToHive();
                      }

                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Column DropdownButtonWidget(
      String title,
      List<DropdownMenuItem<String>>? itemList,
      String dropdownValue,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 5),
          child: Text(
            title,
            style: TextStyle(
                // color: MyTheme.accent_color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins'),
          ),
        ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: double.infinity,
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.add_location_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
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
}
