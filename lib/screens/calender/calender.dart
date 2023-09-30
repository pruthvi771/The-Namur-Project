import 'package:active_ecommerce_flutter/screens/calender/cultivation_tip.dart';
import 'package:active_ecommerce_flutter/screens/calender/pest_control.dart';
import 'package:active_ecommerce_flutter/screens/calender/tutorial.dart';
import 'package:active_ecommerce_flutter/screens/man_machine/man_machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';
import '../../drawer/drawer.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  HomePresenter homeData = HomePresenter();

  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            key: homeData.scaffoldKey,
            drawer: const MainDrawer(),
            backgroundColor: Colors.transparent,
            appBar: buildCustomAppBar(context),
            body: buildBody(),
          ),
        ],
      ),
    );
  }

  RefreshIndicator buildBody() {
    return RefreshIndicator(
      color: MyTheme.white,
      backgroundColor: MyTheme.primary_color,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: bodyscreen(),
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
                IconButton(
                  onPressed: () {
                    homeData.scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.calender_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  height: 30,
                  child: Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  bodyscreen() {
    return Stack(
      children: [
        ListView(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
                child: Container(
              padding: EdgeInsets.only(
                bottom: 2, // Space between underline and text
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Color(0xff107B28),
                width: 1.0, // Underline thickness
              ))),
              child: Text(
                "Calender Events",
                style: TextStyle(
                    //  decoration: TextDecoration.underline,
                    //   decorationThickness: 2,
                    color: Color(0xff107B28),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    letterSpacing: .5),
              ),
            )),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                child: ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                bottom: 1, // Space between underline and text
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Color(0xff107B28),
                                width: 1.0, // Underline thickness
                              ))),
                              child: Text(
                                "Stage-$index",
                                style: TextStyle(
                                    //  decoration: TextDecoration.underline,
                                    //   decorationThickness: 2,
                                    color: Color(0xff107B28),
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    letterSpacing: .5),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Text(
                                    "10Mar23:",
                                    style: TextStyle(
                                        color: MyTheme.primary_color,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins"),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  child: Text(
                                    "Onion Seeding",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins"),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Text(
                                    "10Mar23:",
                                    style: TextStyle(
                                        color: MyTheme.primary_color,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins"),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  child: Text(
                                    "Onion Seeding",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins"),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                color: Color(0xff429525),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Text(
                        "Onion Equipments",
                        style: TextStyle(
                            color: MyTheme.primary_color,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            letterSpacing: .8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            //physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, right: 4),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManMachine()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(0)),
                                        child: Image.asset("assets/tool.png"),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Tool-$index",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins",
                                            letterSpacing: .8),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ))
          ],
        ),
        Positioned(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (index, context) {
                            return Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: MyTheme.primary_color),
                                  ),
                                  child: Image.asset("assets/onion.png"),
                                ),
                                SizedBox(
                                  width: 15,
                                )
                              ],
                            );
                          }),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/add 2.png"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                height: 96,
                width: MediaQuery.of(context).size.width,
                color: Color(0xffC3FF77),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset("assets/pests 1.png"),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Cost Estimate",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins"),
                          )
                        ],
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Tutorial()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.asset("assets/cultivation 1.png"),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Schedule",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins"),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PestControl()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.asset("assets/pests 1 (1).png"),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Pests Control",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins"),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CultivationTips()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child:
                                  Image.asset("assets/cultivation 1 (1).png"),
                            ),
                            SizedBox(height: 3),
                            Text(
                              AppLocalizations.of(context)!
                                  .cultivation_tips_ucf,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins"),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        )),
      ],
    );
  }
}
