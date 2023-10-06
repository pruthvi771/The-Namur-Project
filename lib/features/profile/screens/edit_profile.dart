import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:flutter/material.dart';

import 'package:active_ecommerce_flutter/features/profile/expanded_tile_widget.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/land_screen.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import '../../../custom/device_info.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:percent_indicator/percent_indicator.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final String title = 'KYC';
  var _textController = TextEditingController();
  String hintText = "Email ID";

  Future<void> openBox() async {
    var box = await Hive.openBox('testBox');

    box.put('name', 'David');
    print('Name: ${box.get('name')}');
  }

  void _addDataToHive() {
    var dataBox = Hive.box<ProfileData>('profileDataBox2');

    // dataBox.clear();
    print('so it begins and ens');

    var savedData = dataBox.get('profile');

    if (savedData != null) {
      print('Length: ${savedData.address.length}');
      print(
          'Address0: ${savedData.address[0].district}, ${savedData.address[0].taluk}, ${savedData.address[0].hobli}, ${savedData.address[0].village}');
      // print('Address1: ${savedData.address[1]}');

      for (var address in savedData.address) {
        print(
            'Address: ${address.district}, ${address.taluk}, ${address.hobli}, ${address.village}');
      }
    } else {
      print('Data not found');
    }

    var address = Address()
      ..district = 'delhi'
      ..taluk = 'west'
      ..hobli = 'delho hobti'
      ..village = 'gurgaon';

    var kyc = KYC()
      ..aadhar = 'Aadhar Number'
      ..pan = 'PAN Number'
      ..gst = 'GST Number';

    var land = Land()
      ..village = 'Village Name'
      ..syno = 'Syno Number'
      ..area = 123.45
      ..crops = ['Crop 1', 'Crop 2']
      ..equipments = ['Equipment 1', 'Equipment 2'];

    // var newData = ProfileData()
    //   ..id = 'profile'
    //   ..updated = true
    //   ..kyc = kyc
    //   ..land = [land]; // Assuming you want to store a list of lands

    if (savedData != null) {
      print('object detected');
      var newData = ProfileData()
        ..id = savedData.id
        ..updated = savedData.updated
        ..address = [...savedData.address, address]
        ..kyc = savedData.kyc
        ..land = savedData.land;

      // dataBox.put(newData.id, newData);
      print('object updated');
    } else {
      print('null object detected');
      var newData = ProfileData()
        ..id = 'profile'
        ..updated = true
        ..address = [address]
        ..kyc = kyc
        ..land = [land];

      dataBox.put(newData.id, newData);
      print('object created');
    }
  }

  @override
  Widget build(BuildContext context) {
    var headingText = 'KYC  ';
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
        // key: homeData.scaffoldKey,
        // drawer: const MainDrawer(),
        backgroundColor: Colors.transparent,
        appBar: buildCustomAppBar(context),
        body: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(15),
          children: [
            // The top bar section
            Container(
              height: 40,
              //"Email_ Id" text field
              child: TextField(
                controller: TextEditingController(text: "Email Id"),
                autofocus: false,
                decoration: InputDecorations.buildInputDecoration_1(
                    hint_text: "Email Id"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            HeadingTextWidget(headingText),
            TextFieldWidget(
                'Aadhar', _textController, 'Enter Aadhar Card Number'),
            TextFieldWidget(
                'PAN Card', _textController, 'Enter PAN Card Number'),
            TextFieldWidget('GST Details', _textController, 'Enter GST Number'),
            SizedBox(
              height: 20,
            ),
            HeadingTextWidget('Address Details'),
            TextFieldWidget('District', _textController, 'Enter District'),
            TextFieldWidget('Taluk', _textController, 'Enter Taluk'),
            TextFieldWidget('Hobli', _textController, 'Enter Hobli'),
            TextFieldWidget('Village', _textController, 'Enter Village'),
            SizedBox(
              height: 8,
            ),
            Divider(
              // color: MyTheme.grey_153,
              thickness: 2,
            ),
            SizedBox(
              height: 12,
            ),
            HeadingTextWidget('Land Details'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyTheme.green_lighter,
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('1. Adhaar Card')),
                    Expanded(child: Text('7848749257')),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: MyTheme.green,
                      child: Icon(
                        Icons.check,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextFieldWidget('Village', _textController, 'Enter Village'),
            TextFieldWidget('Syno', _textController, 'Enter Syno'),
            TextFieldWidget('Area', _textController, 'Enter Area'),
            Row(
              children: [
                Expanded(child: SizedBox()),
                TextButton(
                    onPressed: _addDataToHive, child: Text('Add Record')),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              // color: MyTheme.grey_153,
              thickness: 2,
            ),
            SizedBox(
              height: 12,
            ),
            HeadingTextWidget('Crops Grown and Planned'),
            TextFieldWidget('Crop', _textController, 'Enter Crop Name'),
          ],
        ),
      ),
    );
  }

  Padding HeadingTextWidget(String headingText) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 7),
      child: Text(
        headingText,
        style: TextStyle(
            color: MyTheme.accent_color,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            // letterSpacing: .5,
            // decoration: TextDecoration.underline,
            fontFamily: 'Poppins'),
      ),
    );
  }

  Column TextFieldWidget(
      String title, TextEditingController _textController, String hintText) {
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
          child: TextField(
            controller: _textController,
            autofocus: false,
            decoration:
                InputDecorations.buildInputDecoration_1(hint_text: hintText),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
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
                child: Text('Edit Profile',
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
