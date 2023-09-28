import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_exceptions.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_service.dart';
import 'package:active_ecommerce_flutter/ui_elements/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_ecommerce_flutter/screens/password_otp.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login.dart';

class PasswordForget extends StatefulWidget {
  @override
  _PasswordForgetState createState() => _PasswordForgetState();
}

class _PasswordForgetState extends State<PasswordForget> {
  // String _send_code_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US');
  String? _phone = "";

  //controllers
  TextEditingController _emailController = TextEditingController();
  // TextEditingController _phoneNumberController = TextEditingController();

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

  onPressSendCode() async {
    var email = _emailController.text.toString();

    // if (_send_code_by == 'email' && email == "") {
    if (email == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_email,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    // } else if (_send_code_by == 'phone' && _phone == "") {
    //   ToastComponent.showDialog(
    //       AppLocalizations.of(context)!.enter_phone_number,
    //       gravity: Toast.center,
    //       duration: Toast.lengthLong);
    //   return;
    // }
    try {
      await AuthService.firebase().resetPasswordForEmail(email: email);
      ToastComponent.showDialog('Password reset link sent to your email.',
          gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Login();
      }), (newRoute) => false);
    } on InvalidEmailAuthException {
      ToastComponent.showDialog('Invalid email',
          gravity: Toast.center, duration: Toast.lengthLong);
    } on UserNotFoundAuthException {
      ToastComponent.showDialog('User not found. Please register first',
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

    // var passwordForgetResponse = await AuthRepository()
    //     .getPasswordForgetResponse(
    //         _send_code_by == 'email' ? email : _phone, _send_code_by);

    // if (passwordForgetResponse.result == false) {
    //   ToastComponent.showDialog(passwordForgetResponse.message!,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    // } else {
    //   ToastComponent.showDialog(passwordForgetResponse.message!,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return PasswordOtp(
    //       verify_by: _send_code_by,
    //     );
    //   }));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return AuthScreen.buildScreen(
        context, "Forget Password!", buildBody(_screen_width, context));
  }

  Column buildBody(double _screen_width, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: _screen_width,
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 4.0, left: 20, right: 20),
                child: Text(
                  AppLocalizations.of(context)!.email_ucf,
                  style: TextStyle(
                      color: MyTheme.primary_color,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 44,
                      child: TextField(
                        controller: _emailController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "Enter your email"),
                      ),
                    ),
                    // otp_addon_installed.$
                    //     ? GestureDetector(
                    //         onTap: () {
                    //           setState(() {
                    //             _send_code_by = "phone";
                    //           });
                    //         },
                    //         child: Text(
                    //           AppLocalizations.of(context)!
                    //               .or_send_code_via_phone_number,
                    //           style: TextStyle(
                    //               color: MyTheme.accent_color,
                    //               fontStyle: FontStyle.italic,
                    //               decoration: TextDecoration.underline),
                    //         ),
                    //       )
                    //     : Container()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                child: Container(
                  height: 44,
                  child: Btn.basic(
                    minWidth: MediaQuery.of(context).size.width,
                    color: MyTheme.primary_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Send Code",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      onPressSendCode();
                    },
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
