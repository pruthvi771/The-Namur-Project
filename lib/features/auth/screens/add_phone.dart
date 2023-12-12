import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/weather_section_bloc/weather_section_event.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_bloc.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_event.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:active_ecommerce_flutter/features/profile/address_list.dart'
    as addressList;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPhone extends StatefulWidget {
  AddPhone({
    Key? key,
    this.isPrimaryLocation = false,
  }) : super(key: key);

  final bool isPrimaryLocation;

  @override
  State<AddPhone> createState() => _AddPhoneState();
}

class _AddPhoneState extends State<AddPhone> {
  final districts = addressList.districtListForWeather;
  String districtDropdownValue = addressList.districtListForWeather[0];
  // String talukDropdownValue = addressList.districtTalukMap[1][0] as String;

  void initState() {
    currentUser = getCurrentUser();
    super.initState();
  }

  final AuthRepository authRepository = AuthRepository();

  late Future<AuthUser> currentUser;

  Future<AuthUser> getCurrentUser() async {
    var theCurrentUser = authRepository.currentUser!;
    return theCurrentUser;
  }

  TextEditingController _phoneController = TextEditingController();

  String? newPhone2 = "";
  bool isPhoneNumberEmpty = true;

  void addPhoneNumber({required String userId}) async {
    if (isPhoneNumberEmpty) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return null;
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('buyer')
            .doc(userId)
            .update({
          'phone number': newPhone2,
        });
        await FirebaseFirestore.instance
            .collection('seller')
            .doc(userId)
            .update({
          'phone number': newPhone2,
        });
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return Main();
        }), (newRoute) => false);
      } catch (error) {
        ToastComponent.showDialog(
            'Error updating phone number. Please try again.',
            gravity: Toast.center,
            duration: Toast.lengthLong);
        throw Exception('Failed to update phone number. Please try again.');
      }
    }
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
            'More Info',
            // "new ",
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins'),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add Phone Number to Your Account',
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
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
              child: Container(
                height: 40,
                // padding: EdgeInsets.symmetric(horizontal: 10),
                child: IntlPhoneField(
                  disableLengthCheck: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    labelText: 'Mobile Number',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors
                              .green), // Set your desired border color when focused
                    ),
                    // suffixIcon: SizedBox.shrink(),
                  ),
                  cursorColor: MyTheme.green_light,
                  dropdownTextStyle:
                      TextStyle(color: MyTheme.font_grey, fontSize: 13),
                  style: TextStyle(color: MyTheme.font_grey),
                  flagsButtonPadding: EdgeInsets.symmetric(horizontal: 15),
                  showCountryFlag: false,
                  showDropdownIcon: false,
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    setState(() {
                      newPhone2 = '${phone.countryCode} ${phone.number}';
                      // isNewNumberValid = phone.isValidNumber();
                      isPhoneNumberEmpty = phone.number.isEmpty;
                    });
                    print(newPhone2);
                  },
                ),
              ),
            ),

            // SizedBox(
            //   height: 10,
            // ),
            FutureBuilder(
                future: currentUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
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
                                'Add Phone Number',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .5,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              onPressed: () async {
                                addPhoneNumber(userId: snapshot.data!.userId);
                              }),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
          ]),
        ),
      ),
    );
  }
}
