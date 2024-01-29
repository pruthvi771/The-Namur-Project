import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/auth/models/postoffice_response_model.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_bloc.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_event.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_state.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';

import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/otp.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:toast/toast.dart';
import 'package:validators/validators.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // String _register_by = "email"; //phone or email
  String initialCountry = 'US';

  // PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  // var countries_code = <String?>[];

  // String? _phone = "";
  String? newPhone2 = "";
  bool? isNewNumberValid = false;

  bool isPhoneNumberEmpty = true;

  bool? _isAgree = false;
  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  // TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();

  bool isDropdownEnabled = false;
  List<String> locationsList = [];
  String? locationDropdownValue;

  PostOfficeResponse? postOfficeResponse;

  // String? pincode;
  String? addressName;
  String? districtName;
  String? addressCircle;
  String? addressRegion;

  void fetchLocations(BuildContext buildContext) {
    if (_pinCodeController.text.toString().isEmpty ||
        _pinCodeController.text.toString().length != 6) {
      ToastComponent.showDialog('Enter a valid Pincode',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    BlocProvider.of<AuthBloc>(buildContext).add(
      LocationsForPincodeRequested(_pinCodeController.text.toString()),
    );
  }

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressSignUp(BuildContext buildContext) async {
    var name = _nameController.text.toString();
    var email = _emailController.text.toString();
    var pincode = _pinCodeController.text.toString();
    var phone = newPhone2;

    if (name == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_your_name,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (isPhoneNumberEmpty) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (email == "" || !isEmail(email)) {
      ToastComponent.showDialog('Enter a valid email address',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (pincode.isEmpty) {
      ToastComponent.showDialog('Enter a Pin Code and Select A Location',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (locationDropdownValue == null) {
      ToastComponent.showDialog('Select A Location',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    //
    //
    // String newNumber = '+91 $phone_confirm';

    BlocProvider.of<AuthBloc>(buildContext).add(
      SignUpPhoneVerificationRequested(phone!),
    );
  }

  getAddressValues() {
    postOfficeResponse!.postOffices.forEach((postOffice) {
      if (postOffice.name == locationDropdownValue) {
        addressName = postOffice.name;
        districtName = postOffice.district;
        addressCircle = postOffice.circle;
        addressRegion = postOffice.region;
      }
    });
  }

  clearAddressValues() {
    addressName = null;
    districtName = null;
    addressCircle = null;
    addressRegion = null;
  }

  @override
  Widget build(BuildContext context) {
    final _screen_width = MediaQuery.of(context).size.width;

    AuthRepository _authRepository = AuthRepository();
    FirestoreRepository _firestoreRepository = FirestoreRepository();

    return BlocProvider(
      create: (context) => AuthBloc(
          authRepository: _authRepository,
          firestoreRepository: _firestoreRepository),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Success) {
            Navigator.pop(context);
            ToastComponent.showDialog('User created successfully.',
                gravity: Toast.center, duration: Toast.lengthLong);
          }
          if (state is AuthError) {
            final errorMessage =
                state.error.toString().replaceAll('Exception:', '');
            ToastComponent.showDialog(errorMessage.trim(),
                gravity: Toast.center, duration: Toast.lengthLong);
          }
          if (state is LandLocationsForPincodeNotReceived) {
            ToastComponent.showDialog(
                AppLocalizations.of(context)!.service_temporarily_unavailable,
                gravity: Toast.center,
                duration: Toast.lengthLong);
          }
          if (state is LocationsForPincodeReceived) {
            ToastComponent.showDialog(
                AppLocalizations.of(context)!.locations_fetched,
                gravity: Toast.center,
                duration: Toast.lengthLong);
          }
          if (state is SignUpPhoneVerificationCompleted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Otp(
                        verificationId: state.verificationId.toString(),
                        name: _nameController.text.toString(),
                        email: _emailController.text.toString(),
                        signUp: true,
                        // phoneNumber: _phoneNumberController.text.toString(),
                        phoneNumber: newPhone2,
                        pincode: _pinCodeController.text.toString(),
                        addressName: addressName,
                        districtName: districtName,
                        addressCircle: addressCircle,
                        addressRegion: addressRegion,
                      )),
            );
          }
          if (state is LocationsForPincodeReceived) {
            ToastComponent.showDialog('Locations fetched.',
                gravity: Toast.center, duration: Toast.lengthLong);
            postOfficeResponse = state.postOfficeResponse;
            for (var postOffice in state.postOfficeResponse.postOffices) {
              locationsList.add(postOffice.name);
            }
            isDropdownEnabled = true;
            //
            //
          }
          if (state is LocationsForPincodeLoading) {
            locationDropdownValue = null;
            clearAddressValues();
            locationsList.clear();
            ToastComponent.showDialog(
                AppLocalizations.of(context)!.fetching_locations,
                gravity: Toast.center,
                duration: Toast.lengthLong);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is SignUpLoading)
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            return Directionality(
              textDirection:
                  app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
              child: Scaffold(
                backgroundColor: Colors.white,
                bottomSheet: buildBody(context, _screen_width),
                // bottomSheet: Container(
                //   decoration: BoxDecoration(
                //     color: Colors.red,
                //   ),
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [
                //         Container(child: Text('bruce')),
                //         Text('bruce'),
                //         Text('bruce'),
                //         Text('bruce'),
                //         Text('bruce'),
                //       ],
                //     ),
                //   ),
                // ),
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.7,
                    width: DeviceInfo(context).width,
                    child: Image.asset(
                      "assets/Group 211.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container buildBody(BuildContext context, double _screen_width) {
    return Container(
      color: Colors.white,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30),
      //       topRight: Radius.circular(30),
      //     ),
      //     // color: MyTheme.noColor.withOpacity(0)),
      //     color: Colors.red),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 30,
            ),

            // name textbox
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
              child: Container(
                height: 40,
                child: TextField(
                  controller: _nameController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: AppLocalizations.of(context)!.name_ucf),
                ),
              ),
            ),

            SizedBox(
              height: 5,
            ),

            // phone number textbox
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
              child: Container(
                height: 40,
                // padding: EdgeInsets.symmetric(horizontal: 10),
                child: IntlPhoneField(
                  disableLengthCheck: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    labelText: AppLocalizations.of(context)!.phone_number_ucf,
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
                  },
                ),
              ),
            ),

            // email textbox
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                // padding: EdgeInsets.symmetric(horizontal: 20),
                height: 40,
                child: TextField(
                  controller: _emailController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: AppLocalizations.of(context)!.email_ucf),
                ),
              ),
            ),

            // pincode textbox
            Container(
              height: 40,
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      // height: 40,
                      child: TextField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _pinCodeController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text:
                                AppLocalizations.of(context)!.enter_pincode),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      fetchLocations(context);
                    },
                    child: Container(
                      height: double.infinity,
                      color: MyTheme.green_lighter,
                      margin: EdgeInsets.only(
                        left: 10,
                        top: 2,
                        bottom: 2,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.search,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            // location dropdown
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        Colors.grey, // You can customize the border color here
                  ),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    AppLocalizations.of(context)!.select_a_location,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  disabledHint: Text(
                    AppLocalizations.of(context)!.enter_pincode_first,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  value: locationDropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  underline: SizedBox(), // Remove the underline
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Colors.black, // You can customize the text color here
                  ),
                  onChanged: isDropdownEnabled
                      ? (String? newValue) {
                          setState(() {
                            locationDropdownValue = newValue!;
                            getAddressValues();
                          });
                        }
                      : null,
                  items: locationsList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            // privacy policy button
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20, bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    child: Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        value: _isAgree,
                        onChanged: (newValue) {
                          _isAgree = newValue;
                          setState(() {});
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      // top: 15,
                      // bottom: 15,
                    ),
                    child: Container(
                      width: DeviceInfo(context).width! - 130,
                      child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: "I agree to the",
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommonWebviewScreen(
                                                    page_name:
                                                        "Terms Conditions",
                                                    url:
                                                        "${AppConfig.RAW_BASE_URL}/mobile-page/terms",
                                                  )));
                                    },
                                  style:
                                      TextStyle(color: MyTheme.primary_color),
                                  text: " Terms Conditions",
                                ),
                                TextSpan(
                                  text: " &",
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommonWebviewScreen(
                                                    page_name: "Privacy Policy",
                                                    url:
                                                        "${AppConfig.RAW_BASE_URL}/mobile-page/privacy-policy",
                                                  )));
                                    },
                                  text: " Privacy Policy",
                                  style:
                                      TextStyle(color: MyTheme.primary_color),
                                )
                              ])),
                    ),
                  )
                ],
              ),
            ),

            //sign with phone button
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20),
              child: Container(
                height: 44,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAgree!
                      ? () {
                          onPressSignUp(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.primary_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    // 'Sign Up with Phone',
                    AppLocalizations.of(context)!.sign_up_ucf,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            // login instead button
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    AppLocalizations.of(context)!.already_have_an_account,
                    style: TextStyle(color: MyTheme.font_grey, fontSize: 12),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    child: Text(
                      AppLocalizations.of(context)!.log_in,
                      style: TextStyle(
                          color: MyTheme.primary_color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }), (route) => false);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
