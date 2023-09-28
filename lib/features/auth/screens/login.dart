import 'dart:io' show Platform;

import 'package:active_ecommerce_flutter/features/auth/screens/otp.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/password_forget.dart';
// import 'package:active_ecommerce_flutter/screens/password_otp.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/registration.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_exceptions.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:toast/toast.dart';

import '../../../app_config.dart';
import '../../../custom/btn.dart';
import '../../../custom/input_decorations.dart';
import '../../../custom/intl_phone_input.dart';
import '../../../custom/toast_component.dart';
import '../../../helpers/shared_value_helper.dart';
import '../../../my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../repositories/address_repository.dart';
import '../../../ui_elements/auth_ui.dart';
import '../../../screens/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';

  // final _auth = FirebaseAuth.instance;

  // PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  var countries_code = <String?>[];

  String? _phone = "";

  TextEditingController _phoneNumberController = TextEditingController();
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

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var phone = _phoneNumberController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_email,
          gravity: Toast.center, duration: Toast.lengthLong);
      return Main(
        go_back: false,
      );
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (_login_by == 'email' && password == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_password,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_login_by == "phone") {
      try {
        print('+91 $phone');

        final String? verificationId = await AuthService.firebase()
            .phoneNumberVerification(phone: '+91 $phone');
        print('response $verificationId');

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Otp(
                      verify_by: 'phone',
                      verificationId: verificationId.toString(),
                      // resendToken: resendToken,
                    )));
        ToastComponent.showDialog('OTP sent to your phone number',
            gravity: Toast.center, duration: Toast.lengthLong);
      } on GenericAuthException {
        ToastComponent.showDialog('Something went wrong. Please try again.',
            gravity: Toast.center, duration: Toast.lengthLong);
      }
    } else {
      try {
        final user = await AuthService.firebase()
            .loginWithEmail(email: email, password: password);

        // print(user);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return Main();
        }), (newRoute) => false);
      } on UserNotFoundAuthException {
        ToastComponent.showDialog('User not found. Please register first.',
            gravity: Toast.center, duration: Toast.lengthLong);
      } on WrongPasswordAuthException {
        ToastComponent.showDialog('Wrong password. Please try again.',
            gravity: Toast.center, duration: Toast.lengthLong);
      } on InvalidEmailAuthException {
        ToastComponent.showDialog('Invalid email. Please try again.',
            gravity: Toast.center, duration: Toast.lengthLong);
      } on UserDisabledAuthException {
        ToastComponent.showDialog('User is disabled. Please contact support.',
            gravity: Toast.center, duration: Toast.lengthLong);
      } on TooManyRequestsAuthException {
        ToastComponent.showDialog(
            'Maximum requests limit reached. Please try again later',
            gravity: Toast.center,
            duration: Toast.lengthLong);
      } on GenericAuthException {
        ToastComponent.showDialog('Something went wrong. Please try again.',
            gravity: Toast.center, duration: Toast.lengthLong);
      }
    }
  }

  onPressedGoogleLogin() async {
    try {
      final user = await AuthService.firebase().loginWithGoogle();

      ToastComponent.showDialog('Logged in successfully',
          gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Main();
      }), (newRoute) => false);
    } on AccountExistsWithDifferentCredentialAuthException {
      ToastComponent.showDialog(
        'This email is already in use by a different login method.',
        gravity: Toast.center,
        duration: Toast.lengthLong,
      );
    } on OperationNotAllowedAuthException {
      ToastComponent.showDialog(
        'Something went wrong. Please contact support.',
        gravity: Toast.center,
        duration: Toast.lengthLong,
      );
    } on UserDisabledAuthException {
      ToastComponent.showDialog('User is disabled. Please contact support.',
          gravity: Toast.center, duration: Toast.lengthLong);
    } on GenericAuthException {
      ToastComponent.showDialog('Something went wrong. Please try again.',
          gravity: Toast.center, duration: Toast.lengthLong);
    }
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

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    // return Scaffold(
    //     body: LoginScreenUI(_screen_width, context));
    return Scaffold(
      body: AuthScreen.buildScreen(
          context,
          "${AppLocalizations.of(context)!.login_to} " + AppConfig.app_name,
          buildBody(context, _screen_width)),
    );
  }

  Widget buildBody(BuildContext context, double _screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: _screen_width,
          height: MediaQuery.of(context).size.height / 2.01,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ನಮ್ಮೂರ್",
                style: TextStyle(
                    color: MyTheme.primary_color,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: 'Poppins'),
              ),
              Text(
                "Welcome to namur",
                style: TextStyle(
                    color: MyTheme.primary_color,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: 'Poppins'),
              ),
              SizedBox(height: 10),
              (_login_by == "phone") ? SizedBox(height: 30) : Container(),

              if (_login_by == "email")
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        //"Email_ Id" text field
                        child: TextField(
                          controller: _emailController,
                          autofocus: false,
                          decoration: InputDecorations.buildInputDecoration_1(
                              hint_text: "Email Id"),
                        ),
                      ),
                      otp_addon_installed.$
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _login_by = "phone";
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .or_login_with_a_phone,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          : Container()
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        child: CustomInternationalPhoneNumberInput(
                          maxLength: 12,
                          countries: countries_code,
                          initialValue: PhoneNumber(isoCode: 'IN'),
                          // Set the initial value to India (ISO code: 'IN')
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                            setState(() {
                              _phone = number.phoneNumber;
                            });
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            leadingPadding: 0.0,
                            showFlags: false,
                            trailingSpace: false,
                            setSelectorButtonAsPrefixIcon: false,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle:
                              TextStyle(color: MyTheme.font_grey),
                          textStyle: TextStyle(color: MyTheme.font_grey),
                          // initialValue: PhoneNumber(
                          //     isoCode: countries_code[0].toString()),
                          textFieldController: _phoneNumberController,
                          formatInput: false,
                          // Set this to false to remove the space after the 4th character
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputDecoration:
                              InputDecorations.buildInputDecoration_phone(
                                  hint_text: "Mobile Number"),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              //Password textbox
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    (_login_by == "email")
                        ? Container(
                            height: 40,
                            child: TextField(
                              controller: _passwordController,
                              autofocus: false,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      hint_text: "Password"),
                            ),
                          )
                        : Container(),

                    SizedBox(height: 10),

                    //"Forgot Password" Text button
                    if (_login_by == "email")
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PasswordForget();
                          }));
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .login_screen_forgot_password,
                          style: TextStyle(
                              color: MyTheme.primary_color,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                      )
                  ],
                ),
              ),

              //SIGNUP and LOGIN buttons row
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //SIGNUP button
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.textfield_grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          color: MyTheme.primary_color),
                      child: Btn.minWidthFixHeight(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 44,
                        //  color: MyTheme.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          AppLocalizations.of(context)!
                              .login_screen_create_account,
                          style: TextStyle(
                              color: MyTheme.white,
                              fontFamily: 'Poppins',
                              letterSpacing: .5,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registration()));
                        },
                      ),
                    ),

                    SizedBox(width: 20),

                    //LOGIN button
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.textfield_grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: Btn.minWidthFixHeight(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50,
                        color: MyTheme.primary_color,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          AppLocalizations.of(context)!.login_screen_log_in,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: .5,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          onPressedLogin();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //login with email/phone button
              if (_login_by == "email")
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _login_by = "phone";
                      });
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: MyTheme.primary_color),
                          borderRadius: BorderRadius.circular(10)),
                      child: Btn.minWidthFixHeight(
                          minWidth: MediaQuery.of(context).size.width,
                          height: 50,
                          //  color: MyTheme.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Text(
                            AppLocalizations.of(context)!.or_login_with_a_phone,
                            style: TextStyle(
                                color: MyTheme.primary_color,
                                fontFamily: 'Poppins'),
                          )),
                    ),
                  ),
                )
              else
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 25),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _login_by = "email";
                      });
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: MyTheme.primary_color),
                          borderRadius: BorderRadius.circular(10)),
                      child: Btn.minWidthFixHeight(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50,
                        //  color: MyTheme.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Text(
                          AppLocalizations.of(context)!.or_login_with_an_email,
                          style: TextStyle(
                            color: MyTheme.primary_color,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        onPressedGoogleLogin();
                        // print('google');
                      },
                      child: Container(
                        width: 40,
                        child: Image.asset("assets/google_logo.png"),
                      ),
                    ),
                  ],
                ),
              ),

              // if (Platform.isIOS)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 20.0),
              //     child: SignInWithAppleButton(
              //       onPressed: () async {
              //         // signInWithApple();
              //         print('apple');
              //       },
              //     ),
              //   ),
              Container(
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: allow_google_login.$,
                          child: InkWell(
                            onTap: () {
                              onPressedGoogleLogin();
                              // print('google');
                            },
                            child: Container(
                              width: 28,
                              child: Image.asset("assets/google_logo.png"),
                            ),
                          ),
                        ),
                        if (allow_twitter_login.$)
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: InkWell(
                              onTap: () {
                                // onPressedTwitterLogin();
                                print('Twitter');
                              },
                              child: Container(
                                width: 28,
                                child: Image.asset("assets/twitter_logo.png"),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
