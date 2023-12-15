import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/add_phone.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../features/auth/models/auth_user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthUser? user;

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPackageInfo();
    getSharedValueHelperData().then((value) {
      Future.delayed(Duration(milliseconds: 1200)).then((value) async {
        Provider.of<LocaleProvider>(context, listen: false)
            .setLocale(app_mobile_language.$!);

        // user = AuthService.firebase().currentUser;
        final FirebaseAuth auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;
        if (user != null) {
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
              .collection('buyer')
              .doc(user.uid)
              .get();

          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          if (data['phone number'] == null || data['phone number'] == "") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddPhone();
                },
              ),
              (route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Main();
                },
              ),
              (newRoute) => false,
            );
          }
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Login(); // Main(go_back: false,);
              },
            ),
            (route) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return splashScreen();
  }

  Widget splashScreen() {
    return Container(
      width: DeviceInfo(context).height,
      height: DeviceInfo(context).height,
      color: Colors.white,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: "backgroundImageInSplash",
              // child: Ima(
              //   // height: MediaQuery.of(context).size.height / 4.5,
              //   width: MediaQuery.of(context).size.width / 1,
              //   // child: Image.asset("assets/splash.png"),
              //   child: Image.asset("assets/pp.png"),
              // ),
              child: Image.asset(
                "assets/pp2.png",
                width: MediaQuery.of(context).size.width / 2.4,
                // filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Hero(
              tag: "backgroundImageInSplash",
              child: Image.asset(
                "assets/Namur_logo_text.png",
                width: MediaQuery.of(context).size.width / 2.6,
              ),
            ),

            /* Positioned.fill(
              top: DeviceInfo(context).height!/2-72,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Hero(
                      tag: "splashscreenImage",
                      child: Container(
                        height: 500,
                        width: 500,
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                        decoration: BoxDecoration(
                          color: MyTheme.white,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Image.asset(
                            "assets/splash.png",
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      AppConfig.app_name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    "V " + _packageInfo.version,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
*/

            /* Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 51.0),
                  child: Text(
                    AppConfig.copyright_text,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),*/
/*
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                    ],
                  )),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<String?> getSharedValueHelperData() async {
    access_token.load().whenComplete(() {
      AuthHelper().fetch_and_set();
    });
    // AddonsHelper().setAddonsData();
    // BusinessSettingHelper().setBusinessSettingData();
    await app_language.load();
    await app_mobile_language.load();
    await app_language_rtl.load();
    await system_currency.load();
    // Provider.of<CurrencyPresenter>(context, listen: false).fetchListData();

    // print("new splash screen ${app_mobile_language.$}");
    // print("new splash screen app_language_rtl ${app_language_rtl.$}");

    return app_mobile_language.$;
  }
}
