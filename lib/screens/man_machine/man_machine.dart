import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../custom/device_info.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';
import '../../sell_screen/more_detail/more_detail.dart';
import '../../sell_screen/seller_platform/seller_platform.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../drawer/drawer.dart';
import '../option/option.dart';

class ManMachine extends StatefulWidget {
  const ManMachine({Key? key}) : super(key: key);

  @override
  State<ManMachine> createState() => _ManMachineState();
}

class _ManMachineState extends State<ManMachine> {
  HomePresenter homeData = HomePresenter();
  bool isSwitched = false;
  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  bool _switchValue = false;
  String isvalue = "tractor";

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
                IconButton(
                    onPressed: () {
                      homeData.scaffoldKey.currentState?.openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    )),
                Container(
                  height: 30,
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.man_machines_ucf,
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .5,
                            fontFamily: 'Poppins')),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 0, bottom: 10),
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

  bodycontent() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          color: Colors.blueGrey.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 130,
                    child: Stack(
                      children: [
                        for (var i = 0; i < [1, 2, 3, 4].length; i++)
                          Positioned(
                            left: (i * (1 - .4) * 40).toDouble(),
                            top: 0,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.transparent,
                              // Set the background color to transparent
                              backgroundImage: AssetImage(
                                  'assets/Ellipse2.png'), // Provide the asset image path
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '200+10',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black)),
                      TextSpan(
                          text: '\nFarmer',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black))
                    ])),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "Buy",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      //  margin: EdgeInsets.only(right: 50),
                      height: 30,
                      child: Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          // thumb color (round icon)
                          // activeColor: Colors.white,
                          activeTrackColor: Colors.grey.shade400,
                          inactiveThumbColor: Colors.blueGrey.shade600,
                          inactiveTrackColor: Colors.grey.shade400,
                          splashRadius: 50.0,
                          // boolean variable value
                          value: isSwitched,
                          // changes the state of the switch
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "Rent",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 44,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: MyTheme.light_grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isvalue = "tractor";
                    });
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isvalue == "tractor"
                            ? MyTheme.primary_color
                            : Colors.white),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          "Tractor",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w600,
                              color: isvalue == "tractor"
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isvalue = "jcb";
                    });
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isvalue == "jcb"
                            ? MyTheme.primary_color
                            : Colors.white),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          "JCB",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w600,
                              color: isvalue == "jcb"
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isvalue = "equi";
                    });
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isvalue == "equi"
                            ? MyTheme.primary_color
                            : Colors.white),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          "Equipments",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w600,
                              color: isvalue == "equi"
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            child: MasonryGridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              itemCount: 20,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10.0, left: 18, right: 18),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                //
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Option();
                      },
                    ));
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            "assets/tractor.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Tractor",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
