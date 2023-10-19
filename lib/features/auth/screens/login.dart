import 'package:active_ecommerce_flutter/features/auth/screens/otp.dart';
// import 'package:active_ecommerce_flutter/screens/password_otp.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/registration.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_bloc.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_state.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:active_ecommerce_flutter/features/auth/services/auth_service.text';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:toast/toast.dart';

import '../../../app_config.dart';
import '../../../custom/btn.dart';
import '../../../custom/toast_component.dart';
import '../../../my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../repositories/address_repository.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
    fetch_country();
  }

  fetch_country() async {
    var data = await AddressRepository().getCountryList();
    data.countries.forEach((c) => countries_code.add(c.code));
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  // late User loggedInUser;

  onPressedLogin(BuildContext buildContext) async {
    // print('login clicked');
    var email = _emailController.text.toString();
    var phone = newPhone;
    var password = _passwordController.text.toString();

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

  onPressedFacebookLogin() async {
    print('Facebook login attempted');
    // final user = await AuthService.firebase().loginWithGoogle();
    //
    // Navigator.pushAndRemoveUntil(context,
    //     MaterialPageRoute(builder: (context) {
    //       return Main();
    //     }), (newRoute) => false);
  }

  Location location = Location();
  late bool _serviceEnabled;
  late permissionHandler.PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<void> checkLocationPermission() async {
    var dataBox = Hive.box<hiveModels.PrimaryLocation>('primaryLocationBox');

    var savedData = dataBox.get('locationData');

    if (savedData != null) {
      print("saved Latitude: ${savedData.latitude}");
      print("saved Longitude: ${savedData.longitude}");
      return;
    }

    print('no saved location data found');

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
    print("new Latitude: ${_locationData.latitude}");
    print("new Longitude: ${_locationData.longitude}");

    var primaryLocation = hiveModels.PrimaryLocation()
      ..id = "locationData"
      ..isAddress = false
      ..latitude = _locationData.latitude as double
      ..longitude = _locationData.longitude as double
      ..address = "";

    await dataBox.put(primaryLocation.id, primaryLocation);
  }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    AuthRepository _authRepository = AuthRepository();
    FirestoreRepository _firestoreRepository = FirestoreRepository();
    return BlocProvider(
      create: (context) => AuthBloc(
          authRepository: _authRepository,
          firestoreRepository: _firestoreRepository),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is Authenticated) {
            ToastComponent.showDialog('Login Successful',
                gravity: Toast.center, duration: Toast.lengthLong);

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
            ToastComponent.showDialog('OTP sent to your phone number',
                gravity: Toast.center, duration: Toast.lengthLong);

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: _screen_width,
            height: MediaQuery.of(context).size.height / 2.01,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
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

                // SizedBox(height: 10),

                // SizedBox(height: 30),

                // phone text field
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 65,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: IntlPhoneField(
                                disableLengthCheck: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  labelText: 'Mobile Number',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey),
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
                                ),
                                cursorColor: MyTheme.green_light,
                                dropdownTextStyle: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 13),
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
                                  print(newPhone);
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
                                      MediaQuery.of(context).size.width / 2.5,
                                  height: 50,
                                  color: MyTheme.primary_color,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Text(
                                    'Login',
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
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        onPressedGoogleLogin(context);
                                        // print('google');
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 20),
                                child: InkWell(
                                  onTap: () {
                                    // onPressedGoogleLogin(context);
                                    print('facebook');
                                  },
                                  child: Container(
                                    width: 40,
                                    child:
                                        Image.asset("assets/facebook_logo.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 35, top: 10),
                            child: Row(
                              children: [
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Registration()));
                                    },
                                    child: Text(
                                      'Create Account?',
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
                      SizedBox(),
                    ],
                  ),
                ),

                //login button

                // SizedBox(
                //   height: 10,
                // ),

                // //or and divider
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 120),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 3,
                //           height: 10,
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 10),
                //         child: Text('OR',
                //             style: TextStyle(
                //                 color: MyTheme.font_grey,
                //                 fontWeight: FontWeight.w600,
                //                 fontSize: 12,
                //                 fontFamily: 'Poppins')),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 3,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // SizedBox(
                //   height: 10,
                // ),

                // // signup button
                // Padding(
                //   padding: const EdgeInsets.only(left: 30.0, right: 30),
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => Registration()));
                //     },
                //     child: Container(
                //       height: 40,
                //       decoration: BoxDecoration(
                //           border: Border.all(color: MyTheme.primary_color),
                //           borderRadius: BorderRadius.circular(10)),
                //       child: Btn.minWidthFixHeight(
                //           minWidth: MediaQuery.of(context).size.width,
                //           height: 50,
                //           //  color: MyTheme.amber,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: const BorderRadius.all(
                //                   Radius.circular(10.0))),
                //           child: Text(
                //             'Create Account',
                //             style: TextStyle(
                //                 color: MyTheme.primary_color,
                //                 fontFamily: 'Poppins'),
                //           )),
                //     ),
                //   ),
                // ),

                // // google login
              ],
            ),
          )
        ],
      ),
    );
  }
}
