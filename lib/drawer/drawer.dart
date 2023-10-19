import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/about_us/about_us.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/screens/contact_us/contact_us.dart';
import 'package:active_ecommerce_flutter/screens/my_account/my_account.dart';
import 'package:active_ecommerce_flutter/screens/notification/notification_screen.dart';
import 'package:active_ecommerce_flutter/screens/setting/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:active_ecommerce_flutter/features/auth/services/auth_service.text';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wishlist.dart';

import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';

import '../custom/toast_component.dart';
import '../screens/Payment_info/payment_info_screen.dart';
import '../screens/description/description.dart';
import '../screens/option/option.dart';
import '../screens/payment_method_screen/razorpay_screen.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    AuthHelper().clearUserData();

    // var logoutResponse = await AuthRepository().getLogoutResponse();
    //
    // if (logoutResponse.result == true) {
    //   ToastComponent.showDialog(logoutResponse.message, context,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return Login();
    //   }));
    // }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }

  // final user = AuthService.firebase().currentUser;
  final user = 1;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                user != null
                    ? ListTile(
                        // leading: CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //     "${avatar_original.$}",
                        //   ),
                        // ),
                        title: Text(
                          "${user_name.$}",
                          style: TextStyle(
                            color: MyTheme.primary_color,
                          ),
                        ),
                        subtitle: Text(
                          "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                        ))
                    : Text(AppLocalizations.of(context)!.not_logged_in_ucf,
                        style: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14)),
                Divider(),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/language.png",
                        height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(
                        AppLocalizations.of(context)!.change_language_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ChangeLanguage();
                      }));
                    }),
                Divider(),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/home.png",
                        height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                    title: Text(AppLocalizations.of(context)!.home_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Main();
                      }));
                    }),
                Divider(),
                user != null
                    ? Column(
                        children: [
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/profile.png",
                                  height: 16,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text(
                                  AppLocalizations.of(context)!.acccount_ucf,
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MyAccount(show_back_button: true);
                                }));
                              }),
                          Divider(),
                          /* ListTile(
                              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/home.png",
                                  height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text("Payment",
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return RazorpayScreen();
                                    }));
                              }),*/
                          // Divider(),
                          // ListTile(
                          //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          //     leading: Image.asset("assets/home.png",
                          //         height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                          //     title: Text("wallet",
                          //         style: TextStyle(
                          //             color: MyTheme.primary_color,
                          //             fontSize: 14)),
                          //     onTap: () {
                          //       Navigator.push(context,
                          //           MaterialPageRoute(builder: (context) {
                          //             return Main();
                          //           }));
                          //     }),
                          //  Divider(),
                          Visibility(
                            visible: conversation_system_status.$,
                            child: ListTile(
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: -4),
                                leading: Image.asset("assets/chat.png",
                                    height: 16,
                                    color: Color.fromRGBO(153, 153, 153, 1)),
                                title: Text(
                                    AppLocalizations.of(context)!.call_chat_ucf,
                                    style: TextStyle(
                                        color: MyTheme.primary_color,
                                        fontSize: 14)),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MessengerList();
                                  }));
                                }),
                          ),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/home.png",
                                  height: 16,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text(
                                  AppLocalizations.of(context)!.inbox_ucf,
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return NotificationScreen();
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset(
                                "assets/wallet.png",
                                height: 16,
                                color: Color.fromRGBO(153, 153, 153, 1),
                              ),
                              title: Text(
                                  AppLocalizations.of(context)!.wallet_ucf,
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Wallet();
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/order.png",
                                  height: 16,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text(
                                  AppLocalizations.of(context)!
                                      .purchase_history_ucf,
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return OrderList(from_checkout: false);
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/home.png",
                                  height: 16,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text(
                                  AppLocalizations.of(context)!.setting_ucf,
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Setting();
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/home.png",
                                  height: 16,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text(
                                  AppLocalizations.of(context)!.contact_ucf,
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ContactUs();
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/home.png",
                                  height: 16,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text(
                                  AppLocalizations.of(context)!.about_ucf,
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AboutUs();
                                }));
                              }),

                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/home.png",
                                  height: 16,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text("Payment Info",
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PaymentInfo();
                                }));
                              }),

                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/home.png",
                                  height: 16,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text("Option",
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Option();
                                }));
                              }),

                          //TEMPORARY LOGOUT BUTTON
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Icon(Icons.logout),
                              // height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                              title: Text("Logout",
                                  style: TextStyle(
                                      color: MyTheme.primary_color,
                                      fontSize: 18)),
                              onTap: () async {
                                // await AuthService.firebase().logOut();
                                // final user = AuthService.firebase().currentUser;

                                await FirebaseAuth.instance.signOut();
                                final GoogleSignIn googleSignIn =
                                    GoogleSignIn();
                                await googleSignIn.signOut();

                                var dataBox1 =
                                    Hive.box<hiveModels.PrimaryLocation>(
                                        'primaryLocationBox');

                                await dataBox1.clear();

                                var dataBox2 = Hive.box<hiveModels.ProfileData>(
                                    'profileDataBox3');

                                await dataBox2.clear();

                                var dataBox3 =
                                    Hive.box<hiveModels.SecondaryLocations>(
                                        'secondaryLocationsBox');
                                await dataBox3.clear();

                                // final user = null;
                                // if (user == null) {
                                ToastComponent.showDialog('Logout Successful',
                                    gravity: Toast.center,
                                    duration: Toast.lengthLong);
                                // } else {
                                //   ToastComponent.showDialog('Still logged in',
                                //       gravity: Toast.center,
                                //       duration: Toast.lengthLong);
                                // }
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Login(); // Main(go_back: false,);
                                    },
                                  ),
                                  (route) => false,
                                );
                              }),
                        ],
                      )
                    : Container(),
                Divider(height: 24),
                user == null
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/login.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context)!.back_to_Login_ucf,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
                      )
                    : Container(),
                user != null
                    ? InkWell(
                        onTap: () {
                          onTapLogout(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: MyTheme.primary_color),
                            child: Center(
                              child: Text(
                                  AppLocalizations.of(context)!.back_ucf,
                                  style: TextStyle(
                                      color: MyTheme.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      fontSize: 14)),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 150,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// (C:\Users\Piyush Pandey/.ssh/id_ed25519):
