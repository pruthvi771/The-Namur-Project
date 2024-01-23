import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<void> _onPageRefresh() async {}
  final notificationSettings =
      FirebaseMessaging.instance.requestPermission(provisional: true);

  bool _switchValue = false;
  RefreshIndicator buildBody() {
    return RefreshIndicator(
      color: MyTheme.white,
      backgroundColor: MyTheme.primary_color,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: bodycontent(),
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 18),
                  height: 30,
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                        color: MyTheme.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.notification_ucf,
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .5,
                        fontFamily: 'Poppins'),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: buildCustomAppBar(context),
            body: buildBody(),
          ),
        ],
      ),
    );
  }

  bodycontent() {
    return Container(
      child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            child: Image.asset("assets/Vector.png")),
                        Container(
                          width: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Promos And Offers",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Receive Whatsapp updates About Coupons, Promotions And Offers",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: MyTheme.dark_grey,
                                    height: 1.2),
                              )
                            ],
                          ),
                        ),
                        Switch(
                          activeColor: MyTheme.primary_color,
                          value: _switchValue,
                          onChanged: (value) {
                            setState(() {
                              _switchValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
