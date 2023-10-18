import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({Key? key}) : super(key: key);

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  // HomePresenter homeData = HomePresenter();
  bool isSwitched = false;
  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  // bool _switchValue = false;
  // String isvalue = "tractor";

  final stocks = [
    'assets/onion.png',
    'assets/coconut 1.png',
    'assets/bugs.png',
    'assets/orange (1).png',
    'assets/onion.png',
    'assets/coconut 1.png',
    'assets/bugs.png',
    'assets/orange (1).png',
    'assets/onion.png',
    'assets/coconut 1.png',
    'assets/bugs.png',
    'assets/orange (1).png',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // key: homeData.scaffoldKey,
        drawer: const MainDrawer(),
        backgroundColor: Colors.transparent,
        appBar: buildCustomAppBar(context),
        body: bodycontent(),
      ),
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
                      // homeData.scaffoldKey.currentState?.openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    )),
                Container(
                  height: 30,
                  child: Center(
                    child: Text('Parent Screens',
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
        //top bar section

        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          color: Colors.blueGrey.shade50,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20,
              ),
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
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //   child: Row(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //         child: Text(
              //           "Buy",
              //           style: TextStyle(
              //               fontSize: 16, fontWeight: FontWeight.w600),
              //         ),
              //       ),
              //       Container(
              //         //  margin: EdgeInsets.only(right: 50),
              //         height: 30,
              //         child: Transform.scale(
              //           scale: 1.3,
              //           child: Switch(
              //             // thumb color (round icon)
              //             // activeColor: Colors.white,
              //             activeTrackColor: Colors.grey.shade400,
              //             inactiveThumbColor: Colors.blueGrey.shade600,
              //             inactiveTrackColor: Colors.grey.shade400,
              //             splashRadius: 50.0,
              //             // boolean variable value
              //             value: isSwitched,
              //             // changes the state of the switch
              //             onChanged: (value) {
              //               setState(() {
              //                 isSwitched = value;
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //         child: Text(
              //           "Rent",
              //           style: TextStyle(
              //               fontSize: 16, fontWeight: FontWeight.w600),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: MyTheme.field_color,
                ),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Color(0xff4C7B10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    child: Text(
                      "Tractor",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        // color: Colors.black,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Harvester",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Tab(
                  //   child: Text(
                  //     "Cultivator",
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          child: TabBarView(physics: BouncingScrollPhysics(), children: [
            SingleChildScrollView(
              // controller: _xcrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: MasonryGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: stocks.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10.0, left: 18, right: 18),
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  //
                  return Container(
                    //  height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:
                          (index % 5 == 0) ? MyTheme.green_neon : MyTheme.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                              stocks[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            "Grapes",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Text('data2'),
            // Text('data3'),
          ]),
        ),
      ],
    );
  }
}
