import 'package:active_ecommerce_flutter/features/auth/screens/add_phone.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/otp.dart';

import 'package:active_ecommerce_flutter/features/auth/screens/registration.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_bloc.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_state.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/features/weather/weather_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;

import 'package:toast/toast.dart';

import '../../../app_config.dart';
import '../../../custom/btn.dart';
import '../../../custom/toast_component.dart';
import '../../../my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../ui_elements/auth_ui.dart';
import '../../../screens/main.dart';
import '../services/auth_bloc/auth_event.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "phone"; //phone or email
  String initialCountry = 'US';

  // final _auth = FirebaseAuth.instance;

  // PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  var countries_code = <String?>[];
  // String? _isoCode = 'IN';
  // String? _newPhone = '';
  String? newPhone = '';

  WeatherRepository _weatherRepository = WeatherRepository();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
    // fetch_country();
  }

  // fetch_country() async {
  //   var data = await AddressRepository().getCountryList();
  //   data.countries.forEach((c) => countries_code.add(c.code));
  // }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  // late User loggedInUser;

  onPressedLogin(BuildContext buildContext) async {
    //
    var phone = newPhone;

    // if (_login_by == 'email' && email == "") {
    //   ToastComponent.showDialog(AppLocalizations.of(context)!.enter_email,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   return Main(
    //     go_back: false,
    //   );
    // } else
    if (_login_by == 'phone' && phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    // if (_login_by == "phone") {
    // String newNumber = '+91 $phone';
    BlocProvider.of<AuthBloc>(buildContext).add(
      PhoneVerificationRequested(phone!),
    );
  }

  onPressedGoogleLogin(BuildContext buildContext) async {
    BlocProvider.of<AuthBloc>(buildContext).add(
      GoogleSignInRequested(),
    );
  }

  onPressedFacebookLogin(BuildContext context) async {
    ToastComponent.showDialog(
      AppLocalizations.of(context)!.coming_soon,
      gravity: Toast.bottom,
      duration: Toast.lengthLong,
    );
    return;
  }

  Location location = Location();
  late bool _serviceEnabled;
  late permissionHandler.PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<void> checkLocationPermission() async {
    var dataBox = Hive.box<hiveModels.PrimaryLocation>('primaryLocationBox');

    var savedData = dataBox.get('locationData');

    if (savedData != null) {
      return;
    }

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await permissionHandler.Permission.location.request();
    if (_permissionGranted != permissionHandler.PermissionStatus.granted) {
      return;
    }

    _locationData = await location.getLocation();

    String? address = await _weatherRepository.getNameFromLatLong(
        _locationData.latitude!, _locationData.longitude!);

    if (address == null) {}

    var primaryLocation = hiveModels.PrimaryLocation()
      ..id = "locationData"
      ..isAddress = false
      ..latitude = _locationData.latitude as double
      ..longitude = _locationData.longitude as double
      ..address = address;

    await dataBox.put(primaryLocation.id, primaryLocation);
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
        listener: (context, state) async {
          if (state is NeedToAddPhoneNumberState) {
            await checkLocationPermission();
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return AddPhone();
            }), (newRoute) => false);
          }
          if (state is Authenticated) {
            // ToastComponent.showDialog(AppLocalizations.of(context)!
            //                               .if_you_are_finding_any_problem_while_logging_in,
            //     gravity: Toast.center, duration: Toast.lengthLong);

            await checkLocationPermission();

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return Main();
            }), (newRoute) => false);
          }
          if (state is AuthError) {
            final errorMessage =
                state.error.toString().replaceAll('Exception:', '');
            ToastComponent.showDialog(errorMessage.trim(),
                gravity: Toast.center, duration: Toast.lengthLong);
          }
          if (state is PhoneVerificationCompleted) {
            // ToastComponent.showDialog('OTP sent to your phone number',
            //     gravity: Toast.center, duration: Toast.lengthLong);
            ToastComponent.showDialog(
                AppLocalizations.of(context)!.otp_sent_to_phone,
                gravity: Toast.center,
                duration: Toast.lengthLong);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Otp(verificationId: state.verificationId.toString()
                            // resendToken: resendToken
                            )));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading)
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            if (state is Authenticated)
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            return Scaffold(
              body: AuthScreen.buildScreen(
                  context,
                  "${AppLocalizations.of(context)!.login_to} " +
                      AppConfig.app_name,
                  buildBody(context, _screen_width)),
            );
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, double _screen_width) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: _screen_width,
                height: MediaQuery.of(context).size.height / 2.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      padding: const EdgeInsets.only(right: 30),
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangeLanguage()));
                            },
                            child: FaIcon(
                              FontAwesomeIcons.language,
                              color: MyTheme.primary_color,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Column(
                        children: [
                          Text(
                            "ನಮ್ಮೂರ್",
                            style: TextStyle(
                              color: MyTheme.primary_color,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to Namur",
                            style: TextStyle(
                                color: MyTheme.primary_color,
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),

                    // phone text field
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 75,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: IntlPhoneField(
                                    pickerDialogStyle: PickerDialogStyle(
                                      backgroundColor: Colors.white,
                                      searchFieldInputDecoration:
                                          InputDecoration(
                                        hintText: AppLocalizations.of(context)!
                                            .search,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                    ),
                                    disableLengthCheck: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      labelText: AppLocalizations.of(context)!
                                          .phone_number_ucf,
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black),
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
                                      fillColor: Colors.white,
                                    ),
                                    cursorColor: MyTheme.green_light,
                                    dropdownTextStyle: TextStyle(
                                        color: MyTheme.font_grey, fontSize: 15),
                                    style: TextStyle(color: MyTheme.font_grey),
                                    flagsButtonPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    showCountryFlag: false,
                                    showDropdownIcon: false,
                                    initialCountryCode: 'IN',
                                    onChanged: (phone) {
                                      setState(() {
                                        newPhone =
                                            '${phone.countryCode} ${phone.number}';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(right: 10),
                                    height: 44,
                                    child: Btn.minWidthFixHeight(
                                      minWidth:
                                          MediaQuery.of(context).size.width /
                                              2.5,
                                      height: 50,
                                      color: MyTheme.primary_color,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .login_screen_log_in,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () {
                                        onPressedLogin(context);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            onPressedGoogleLogin(context);
                                            //
                                          },
                                          child: Container(
                                            width: 40,
                                            child: Image.asset(
                                                "assets/google_logo.png"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 10, right: 20),
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       // onPressedGoogleLogin(context);
                                  //       onPressedFacebookLogin(context);
                                  //     },
                                  //     child: Container(
                                  //       width: 40,
                                  //       child: Image.asset(
                                  //           "assets/facebook_logo.png"),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 35, top: 10),
                                child: Row(
                                  children: [
                                    Expanded(child: SizedBox()),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Registration()));
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .login_screen_or_create_new_account,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: MyTheme.grey_153,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
