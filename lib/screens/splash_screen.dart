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
    super.initState();
    _initPackageInfo();
    getSharedValueHelperData().then((value) {
      Future.delayed(Duration(milliseconds: 1200)).then(
        (value) async {
          Provider.of<LocaleProvider>(context, listen: false)
              .setLocale(app_mobile_language.$!);

          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          if (user != null) {
            DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                .collection('buyer')
                .doc(user.uid)
                .get();

            try {
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
                    builder: (BuildContext context) {
                      return Main();
                    },
                  ),
                  (newRoute) => false,
                );
              }
            } catch (e) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Login();
                  },
                ),
                (route) => false,
              );
            }
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return Login();
                },
              ),
              (route) => false,
            );
          }
        },
      );
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
              child: Image.asset(
                "assets/pp2.png",
                width: MediaQuery.of(context).size.width / 2.4,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset(
              "assets/kannada-font.png",
              width: MediaQuery.of(context).size.width,
              height: 100,
              fit: BoxFit.fitHeight,
            ),
            Stack(
              children: [
                Image.asset(
                  "assets/namur-english-splashbackground.png",
                  width: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  right: -MediaQuery.of(context).size.width / 5.5,
                  child: Image.asset(
                    "assets/namur-splash-text.png",
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getSharedValueHelperData() async {
    access_token.load().whenComplete(() {
      AuthHelper().fetch_and_set();
    });

    await app_language.load();
    await app_mobile_language.load();
    await app_language_rtl.load();
    await system_currency.load();

    return app_mobile_language.$;
  }
}
