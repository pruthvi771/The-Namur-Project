import 'package:active_ecommerce_flutter/features/profile/expanded_tile_widget.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../../../custom/device_info.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:percent_indicator/percent_indicator.dart';

// import '../seller_platform/seller_platform.dart';

class LandScreen extends StatefulWidget {
  const LandScreen({Key? key}) : super(key: key);

  @override
  State<LandScreen> createState() => _LandScreenState();
}

class _LandScreenState extends State<LandScreen> with TickerProviderStateMixin {
  // final _controller1 = ExpandedTileController();
  final _controller2 = new ExpandedTileController();

  String title = "KYC";
  final double progress = 0.80;

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: buildCustomAppBar(context),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: MyTheme.field_color,
                      ),
                      // color: MyTheme.field_color,
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        // color: MyTheme.green,
                        color: Color(0xff4C7B10),
                      ),
                      controller: tabController,
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 25),
                      tabs: [
                        Tab(
                          child: Text(
                            '1. Yare Hola',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .5,
                              color: Color.fromARGB(255, 212, 212, 212),
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            '2. Bale Tota',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .5,
                              color: Color.fromARGB(255, 212, 212, 212),
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            '3. Koplu Gadde',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .5,
                              color: Color.fromARGB(255, 212, 212, 212),
                              // color: Color.fromARGB(255, 234, 234, 234),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          LandExpandedTile(
                            controller2: _controller2,
                            title: title,
                            content: Container(
                              padding: EdgeInsets.only(top: 8),
                              height: 150,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 60,
                                    child: Container(
                                      child: Image.asset(
                                        'assets/girl.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyTheme.green_lighter,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Size: 19 acres',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: .5,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            Text(
                                              'Sy No: 200, 201',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: .5,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            Text(
                                              'Groundnut: 2 Ton',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: .5,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            Text(
                                              'Onion: 5 Ton',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: .5,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            Text(
                                              'Papaya: 1 ton',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: .5,
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          LandExpandedTile(
                            controller2: _controller2,
                            title: title,
                            content: Container(
                                padding: EdgeInsets.only(top: 8),
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Text('tab1'),
                                    Text('tab1'),
                                    Text('tab1'),
                                    Text('tab1'),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Center(child: Text('tab2')),
                      Center(child: Text('tab3')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // RefreshIndicator buildBody() {
  //   return RefreshIndicator(
  //     color: MyTheme.white,
  //     backgroundColor: MyTheme.primary_color,
  //     onRefresh: _onPageRefresh,
  //     displacement: 10,
  //     child: bodycontent(),
  //   );
  // }

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
                SizedBox(
                  width: 30,
                ),
                Center(
                  child: Text('Land',
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
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
}

class LandExpandedTile extends StatelessWidget {
  const LandExpandedTile({
    super.key,
    required ExpandedTileController controller2,
    required this.title,
    required this.content,
  }) : _controller2 = controller2;

  final ExpandedTileController _controller2;
  final String title;
  final Container content;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0),
      child: ExpandedTile(
        theme: const ExpandedTileThemeData(
          headerColor: MyTheme.green_lighter,
          headerPadding: EdgeInsets.all(7),
          headerSplashColor: Color.fromARGB(198, 131, 200, 116),
          contentBackgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(0),
          contentRadius: 0,
          headerRadius: 0,
        ),
        contentseparator: 0,
        controller: _controller2,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/dropdown.png',
            height: 15,
          ),
        ),
        content: content,
      ),
    );
  }
}
