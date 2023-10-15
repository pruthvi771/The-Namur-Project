import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/features/profile/expanded_tile_widget.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/land_screen.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../custom/device_info.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:percent_indicator/percent_indicator.dart';

// import '../seller_platform/seller_platform.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  // final _controller1 = ExpandedTileController();
  // final _controller2 = new ExpandedTileController();
  // final _controller3 = new ExpandedTileController();
  // final _controller35 = new ExpandedTileController();
  // final _controller4 = new ExpandedTileController();
  // final _controller5 = new ExpandedTileController();

  Future<List<Object?>> getNumberOfFriends() async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');

    if (savedData!.address[0].pincode.isEmpty) {
      throw Exception('Failed to load data');
    }

    int count = 0;
    String villageName = savedData.address[0].village;
    String pincode = savedData.address[0].pincode;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('buyer')
        .where(FieldPath.documentId, isNotEqualTo: null)
        .where('profileData', isNotEqualTo: null)
        .get();

    List<DocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;

    for (var document in documents) {
      Map<String, dynamic> data = document.data()!;
      if (data['profileData']['address'][0]['pincode'] == pincode) {
        count++;
        print('count incremented');
      }
      print(data['profileData']['address'][0]['pincode']);
    }

    return [villageName, pincode, count];
  }

  String title = "KYC";
  final double progress = 0.80;

  final String image = "assets/onion.png";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
        // key: homeData.scaffoldKey,
        // drawer: const MainDrawer(),
        backgroundColor: Colors.transparent,
        appBar: buildCustomAppBar(context),
        body: ListView(
            padding: EdgeInsets.all(8),
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: MyTheme.green_lighter,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(3),
                          child: Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  child: CircleAvatar(
                                    backgroundColor: MyTheme.white,
                                    radius: 45,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: 5,
                                  child: ClipRRect(
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/girl.png"),
                                      radius: 40,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 55,
                                  child: ClipRRect(
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: MyTheme.green,
                                      child: Icon(
                                        Icons.check,
                                        size: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: getNumberOfFriends(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${snapshot.data![2]} friends & neighbours',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0,
                                            color: Colors.black)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('0 Groups',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0,
                                            color: Colors.black)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        'Society: ${snapshot.data![0]} ${snapshot.data![1]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.0,
                                            color: Colors.black)),
                                  ],
                                );
                              }
                              if (snapshot.hasError) {
                                return Text(
                                  'Add Address To See This',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.red),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),

              // Groups Text
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Groups',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                        )),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 100,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      GroupWidget(image: "assets/onion.png"),
                      GroupWidget(image: "assets/onion.png"),
                      GroupWidget(image: "assets/onion.png"),
                      GroupWidget(image: "assets/onion.png"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Society: Pitlali 577511 (125 Members)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                        )),
                  )),
              MasonryGridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: 50,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 8),
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  //
                  return ClipOval(
                    child: InkWell(
                      onTap: () => print('tapped $index'),
                      child: Container(
                        // height: 50,
                        // width: 50,
                        child: Stack(children: [
                          AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Image.asset(
                              (index % 3 == 0)
                                  ? 'assets/Ellipse2.png'
                                  : 'assets/Ellipse3.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          (index % 3 == 0)
                              ? Positioned(
                                  bottom: 10,
                                  left: 50,
                                  child: ClipRRect(
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: MyTheme.green,
                                      child: Icon(
                                        Icons.check,
                                        size: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ]),
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
                SizedBox(
                  width: 30,
                ),
                Center(
                  child: Text('Friends',
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

class GroupWidget extends StatelessWidget {
  const GroupWidget({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
