import 'package:active_ecommerce_flutter/features/notification/notification_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/more_details.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/my_purchases.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/seller_inventory.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/about_us/about_us.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/screens/my_account/my_account.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:active_ecommerce_flutter/screens/main.dart';

import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';

import '../custom/toast_component.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }

  // final user = AuthService.firebase().currentUser;

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
                SizedBox(
                  height: 30,
                ),

                Divider(),

                // change language
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.translate_outlined,
                    ),
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

                // home
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.home_outlined,
                    ),
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

                // my account
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.person,
                    ),
                    title: Text(AppLocalizations.of(context)!.acccount_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyAccount();
                      }));
                    }),

                Divider(),

                // TODO: Navigation route up
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.notifications_outlined,
                    ),
                    title: Text(AppLocalizations.of(context)!.inbox_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NotificationScreen();
                      }));
                    }),

                Divider(),

                // wallet
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.wallet_outlined,
                      // size: 23,
                    ),
                    title: Text(AppLocalizations.of(context)!.wallet_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      ToastComponent.showDialog(
                          '${AppLocalizations.of(context)!.coming_soon}...',
                          gravity: Toast.center,
                          duration: Toast.lengthLong);
                    }),

                Divider(),

                // purchase history
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.inventory_outlined,
                    ),
                    title: Text(AppLocalizations.of(context)!.my_inventory,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SellerInventory();
                      }));
                    }),

                Divider(),

                // purchase history
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.list_alt_outlined,
                    ),
                    title: Text(
                        AppLocalizations.of(context)!.purchase_history_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PurchaseHistoryScreen();
                      }));
                    }),

                Divider(),

                // settings
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.settings_outlined,
                    ),
                    title: Text(AppLocalizations.of(context)!.setting_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MoreDetails();
                      }));
                    }),

                Divider(),

                // TODO: Contact us page
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(
                      Icons.phone_outlined,
                      size: 23,
                    ),
                    title: Text(AppLocalizations.of(context)!.contact_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return ContactUs();
                      // }));
                    }),

                Divider(),

                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    // leading: Image.asset("assets/home.png",
                    //     height: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                    leading: Icon(
                      Icons.info_outline,
                      // size: 23,
                    ),
                    title: Text(AppLocalizations.of(context)!.about_ucf,
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AboutUs();
                      }));
                    }),

                //TEMPORARY LOGOUT BUTTON
                Divider(),

                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Icon(Icons.logout),
                    title: Text("Logout",
                        style: TextStyle(
                            color: MyTheme.primary_color, fontSize: 18)),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      final GoogleSignIn googleSignIn = GoogleSignIn();
                      await googleSignIn.signOut();

                      var dataBox1 = Hive.box<hiveModels.PrimaryLocation>(
                          'primaryLocationBox');
                      await dataBox1.clear();

                      var dataBox2 =
                          Hive.box<hiveModels.ProfileData>('profileDataBox3');
                      await dataBox2.clear();

                      var dataBox3 = Hive.box<hiveModels.SecondaryLocations>(
                          'secondaryLocationsBox');
                      await dataBox3.clear();

                      var dataBox4 = Hive.box<hiveModels.CropCalendarData>(
                          'cropCalendarDataBox');
                      await dataBox4.clear();

                      ToastComponent.showDialog('Logout Successful',
                          gravity: Toast.center, duration: Toast.lengthLong);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Login();
                          },
                        ),
                        (route) => false,
                      );
                    }),

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
