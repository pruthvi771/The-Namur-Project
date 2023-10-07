//modified

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/google_recaptcha.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_bloc.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_event.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_state.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
// import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/otp.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_exceptions.dart';
// import 'package:active_ecommerce_flutter/features/auth/services/auth_service.text';
import 'package:active_ecommerce_flutter/ui_elements/auth_ui.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:toast/toast.dart';
import 'package:validators/validators.dart';

import '../../../repositories/address_repository.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "email"; //phone or email
  String initialCountry = 'US';

  // PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  var countries_code = <String?>[];

  String? _phone = "";
  bool? _isAgree = false;
  bool _isCaptchaShowing = false;
  String googleRecaptchaKey = "";

  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

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

  onPressSignUp(BuildContext buildContext) async {
    var name = _nameController.text.toString();
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();
    var phone_confirm = _phoneNumberController.text.toString();

    if (name == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_your_name,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_register_by == 'email' && (email == "" || !isEmail(email))) {
      ToastComponent.showDialog('Enter a valid email address',
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_register_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_password,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (password_confirm == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.confirm_your_password,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!
              .password_must_contain_at_least_6_characters,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    } else if (password != password_confirm) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.passwords_do_not_match,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    if (_register_by == "phone") {
      print('phone login attempted');
    } else {
      BlocProvider.of<AuthBloc>(buildContext)
          .add(SignUpWithEmailRequested(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    AuthRepository _authRepository = AuthRepository();
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: _authRepository),
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
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading)
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            return AuthScreen.buildScreen(
                context,
                "${AppLocalizations.of(context)!.join_ucf} " +
                    AppConfig.app_name,
                buildBody(context, _screen_width));
          },
        ),
      ),
    );
  }

  Column buildBody(BuildContext context, double _screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*  Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 20),
                child: Text(
                  AppLocalizations.of(context)!.name_ucf,
                  style: TextStyle(
                      color: MyTheme.primary_color,
                      fontWeight: FontWeight.w600),
                ),
              ),*/
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
                child: Container(
                  height: 40,
                  child: TextField(
                    controller: _nameController,
                    autofocus: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: "Enter your name"),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              /* Padding(
                padding:
                    const EdgeInsets.only(bottom: 4.0, right: 20, left: 20),
                child: Text(
                  _register_by == "email"
                      ? AppLocalizations.of(context)!.email_ucf
                      : AppLocalizations.of(context)!.phone_ucf,
                  style: TextStyle(
                      color: MyTheme.primary_color,
                      fontWeight: FontWeight.w600),
                ),
              ),*/
              if (_register_by == "email")
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        child: TextField(
                          controller: _emailController,
                          autofocus: false,
                          decoration: InputDecorations.buildInputDecoration_1(
                              hint_text: "Email Id"),
                        ),
                      ),
                      // otp_addon_installed.$
                      //     ?
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _register_by = "phone";
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .or_register_with_a_phone,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                      )
                      // : Container()
                    ],
                  ),
                )
              else
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        child: CustomInternationalPhoneNumberInput(
                          maxLength: 10,
                          countries: countries_code,
                          initialValue: PhoneNumber(isoCode: 'IN'),
                          onInputChanged: (PhoneNumber number) {
                            String? phoneNumber = number.phoneNumber;
                            if (phoneNumber?.length == 10) {
                              print(phoneNumber);
                              setState(() {
                                _phone = phoneNumber;
                              });
                            } else {
                              print("Invalid phone number");
                            }
                          },
                          // Rest of the code...
                          /* onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                            setState(() {
                              _phone = number.phoneNumber;
                            });
                          },*/
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                              showFlags: false,
                              trailingSpace: false),

                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle:
                              TextStyle(color: MyTheme.font_grey),
                          // initialValue: PhoneNumber(
                          //     isoCode: countries_code[0].toString()),
                          textFieldController: _phoneNumberController,
                          formatInput: false, // Disable default formatting
                          keyboardType: TextInputType.number,
                          /* formatInput: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),*/
                          inputDecoration:
                              InputDecorations.buildInputDecoration_phone(
                                  hint_text: "Phone Number"),
                          onSaved: (PhoneNumber number) {
                            //print('On Saved: $number');
                          }, // Limit input to 10 digits
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _register_by = "email";
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .or_register_with_an_email,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
              SizedBox(
                height: 5,
              ),

              /*  Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 20),
                child: Text(
                  AppLocalizations.of(context)!.password_ucf,
                  style: TextStyle(
                      color: MyTheme.primary_color,
                      fontWeight: FontWeight.w600),
                ),
              ),*/

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 40,
                      child: TextField(
                        controller: _passwordController,
                        autofocus: false,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "Enter your password"),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .password_must_contain_at_least_6_characters,
                      style: TextStyle(
                          color: MyTheme.textfield_grey,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              ),

              /*Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 20),
                child: Text(
                  AppLocalizations.of(context)!.retype_password_ucf,
                  style: TextStyle(
                      color: MyTheme.primary_color,
                      fontWeight: FontWeight.w600),
                ),
              ),*/

              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 20, right: 20),
                child: Container(
                  height: 44,
                  child: TextField(
                    controller: _passwordConfirmController,
                    autofocus: false,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: "Enter your password"),
                  ),
                ),
              ),
              if (google_recaptcha.$)
                Container(
                  height: _isCaptchaShowing ? 350 : 50,
                  width: 300,
                  child: Captcha(
                    (keyValue) {
                      googleRecaptchaKey = keyValue;
                      setState(() {});
                    },
                    handleCaptcha: (data) {
                      if (_isCaptchaShowing.toString() != data) {
                        _isCaptchaShowing = data;
                        setState(() {});
                      }
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20),
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
                      padding: const EdgeInsets.only(left: 8.0),
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
                                                      page_name:
                                                          "Privacy Policy",
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
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20),
                child: Container(
                  height: 44,
                  child: Btn.minWidthFixHeight(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    color: MyTheme.primary_color,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                      AppLocalizations.of(context)!.sign_up_ucf,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: _isAgree!
                        ? () {
                            onPressSignUp(context);
                          }
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 20),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
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
      ],
    );
  }
}
