import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_bloc.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_event.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_state.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/enum.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/my_theme.dart';
// import 'package:active_ecommerce_flutter/features/auth/services/auth_service.text';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
// import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:otp_text_field/style.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:otp_text_field/otp_text_field.dart';

import 'package:active_ecommerce_flutter/screens/main.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class Otp extends StatefulWidget {
  Otp(
      {Key? key,
      this.signUp = false,
      // this.user_id,
      this.name,
      this.email,
      this.phoneNumber,
      required this.verificationId})
      : super(key: key);
  final bool signUp;
  // final String? user_id;
  final String verificationId;
  final String? name;
  final String? email;
  final String? phoneNumber;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();
  OtpFieldController _verificationController = OtpFieldController();
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

  // onTapResend() async {
  //   var resendCodeResponse = await AuthRepository()
  //       .getResendCodeResponse(widget.user_id, widget.verify_by);
  //   if (resendCodeResponse.result == false) {
  //     ToastComponent.showDialog(resendCodeResponse.message!,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //   } else {
  //     ToastComponent.showDialog(resendCodeResponse.message!,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //   }
  // }

  onPressConfirm(BuildContext buildContext) async {
    // var code = _verificationController.toString();
    String code = otp.join('');
    print('OTP: $code');

    if (code == "") {
      ToastComponent.showDialog(
        AppLocalizations.of(context)!.enter_verification_code,
        gravity: Toast.center,
        duration: Toast.lengthLong,
      );
      return;
    }
    if (otp.length < 6) {
      ToastComponent.showDialog(
        'Please enter full code',
        gravity: Toast.center,
        duration: Toast.lengthLong,
      );
      return;
    }

    if (widget.signUp) {
      BlocProvider.of<AuthBloc>(buildContext)
          .add(SignUpWithPhoneNumberRequested(
        widget.verificationId,
        code,
        widget.name!,
        widget.email!,
        widget.phoneNumber!,
      ));
    } else {
      BlocProvider.of<AuthBloc>(buildContext)
          .add(SignInWithPhoneNumberRequested(widget.verificationId, code));
    }
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

  List<String> otp = List.filled(6, ''); // Change the size to 6

  @override
  Widget build(BuildContext context) {
    // String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;

    AuthRepository _authRepository = AuthRepository();
    FirestoreRepository _firestoreRepository = FirestoreRepository();

    if (widget.signUp) {
      print('yes yes, Signup is true bro');
    } else {
      print('Signup is NOT true');
    }

    return BlocProvider(
      create: (context) => AuthBloc(
          authRepository: _authRepository,
          firestoreRepository: _firestoreRepository),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthError) {
            final errorMessage =
                state.error.toString().replaceAll('Exception:', '');
            ToastComponent.showDialog(errorMessage.trim(),
                gravity: Toast.center, duration: Toast.lengthLong);
          }
          if (state is Authenticated) {
            ToastComponent.showDialog(
              'Login Successful',
              gravity: Toast.center,
              duration: Toast.lengthLong,
            );
            await checkLocationPermission();
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return Main();
            }), (newRoute) => false);
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
            return Directionality(
                textDirection:
                    app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    'assets/Group 211.png',
                                    fit: BoxFit.cover,
                                  ))),
                          SizedBox()
                        ],
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height / 2 - 20,
                        // left: 0,
                        // right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Container(
                              decoration: BoxDecoration(
                                  color: MyTheme.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))),
                              width: _screen_width,
                              height: MediaQuery.of(context).size.height / 2.01,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20.0, top: 20),
                                    child: Text(
                                      "Enter OTP Code",
                                      /*  + (_verify_by == "email"
                                      ? AppLocalizations.of(context)!.email_account_ucf
                                      : AppLocalizations.of(context)!.phone_number_ucf),*/
                                      style: TextStyle(
                                          color: MyTheme.primary_color,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: _screen_width * (3 / 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: OTPTextField(
                                            obscureText: true,
                                            controller: _verificationController,
                                            length:
                                                6, // Change this to 6 for a 6-digit OTP
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            textFieldAlignment:
                                                MainAxisAlignment.spaceAround,
                                            otpFieldStyle: OtpFieldStyle(
                                              backgroundColor:
                                                  Color(0xffC3FF77),
                                            ),
                                            fieldWidth: 40,
                                            fieldStyle: FieldStyle.box,
                                            outlineBorderRadius: 10,
                                            style: TextStyle(fontSize: 17),
                                            onChanged: (pin) {
                                              setState(() {
                                                otp = pin.split('');
                                              });
                                              print("Changed: " + pin);
                                            },
                                            onCompleted: (pin) {
                                              print("Completed: " + pin);
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 80),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 40.0),
                                            child: Container(
                                              height: 50,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: MyTheme
                                                          .textfield_grey,
                                                      width: 1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              12.0))),
                                              child: Btn.basic(
                                                minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: MyTheme.accent_color,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                12.0))),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .confirm_ucf,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      letterSpacing: .5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Poppins'),
                                                ),
                                                onPressed: () {
                                                  onPressConfirm(context);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }

  Widget otpBoxBuilder(_controller, index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffC3FF77),
      ),
      width: 50, // Adjust the width to accommodate 6 digits
      height: 50,
      child: TextFormField(
        controller: _controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        decoration: InputDecoration(
          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          counterText: '',
          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          otp[index] = value; // Update the corresponding index in the otp list
        },
      ),
    );
  }
}
