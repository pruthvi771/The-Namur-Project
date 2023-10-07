import 'package:active_ecommerce_flutter/features/profile/expanded_tile_widget.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/edit_profile.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/land_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/profile.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import '../../../custom/device_info.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:percent_indicator/percent_indicator.dart';

// import '../seller_platform/seller_platform.dart';

class MoreDetails extends StatefulWidget {
  const MoreDetails({Key? key}) : super(key: key);

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  final _controller1 = ExpandedTileController();
  final _controller2 = new ExpandedTileController();
  final _controller3 = new ExpandedTileController();
  final _controller35 = new ExpandedTileController();
  final _controller4 = new ExpandedTileController();
  final _controller5 = new ExpandedTileController();

  late double progress;
  late ProfileData? profileData;

  void calculatingProgress(profileData) {
    var tempProgress = 0.0;

    if (!(profileData.address.length == 0)) {
      tempProgress += 0.2;
    }
    if (!profileData.kyc.aadhar.isEmpty) {
      tempProgress += 0.2;
    }
    if (!profileData.kyc.pan.isEmpty) {
      tempProgress += 0.2;
    }
    if (!profileData.kyc.gst.isEmpty) {
      tempProgress += 0.2;
    }
    if (!(profileData.land.length == 0)) {
      tempProgress += 0.2;
    }

    progress = tempProgress;
  }

  @override
  void initState() {
    super.initState();
    var dataBox = Hive.box<ProfileData>('profileDataBox3');
    var savedData = dataBox.get('profile');
    if (savedData == null) {
      var kyc = KYC()
        ..aadhar = ''
        ..pan = ''
        ..gst = '';
      var emptyProfileData = ProfileData()
        ..id = 'profile'
        ..updated = true
        ..address = []
        ..kyc = kyc
        ..land = [];
      dataBox.put(emptyProfileData.id, emptyProfileData);
    }
    // setState(() {
    //   profileData = dataBox.get('profile');
    //   calculatingProgress(profileData);
    // });
    profileData = dataBox.get('profile');
    calculatingProgress(profileData);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (ModalRoute.of(context)!.isCurrent) {
  //     var dataBox = Hive.box<ProfileData>('profileDataBox3');
  //     profileData = dataBox.get('profile');

  //     if (profileData == null) {
  //       var kyc = KYC()
  //         ..aadhar = ''
  //         ..pan = ''
  //         ..gst = '';
  //       var emptyProfileData = ProfileData()
  //         ..id = 'profile'
  //         ..updated = true
  //         ..address = []
  //         ..kyc = kyc
  //         ..land = [];
  //       dataBox.put(emptyProfileData.id, emptyProfileData);
  //       setState(() {
  //         profileData = emptyProfileData;
  //         calculatingProgress(profileData);
  //       });
  //     }
  //   }
  // }

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
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          children: [
            // The top bar section
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: MyTheme.dark_grey,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: CircleAvatar(
                            backgroundColor: MyTheme.light_grey,
                            radius: 40,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: ClipRRect(
                            child: CircleAvatar(
                              backgroundImage: AssetImage("assets/girl.png"),
                              radius: 40,
                            ),
                          ),
                        ),
                        Positioned(
                          // top: 10,
                          // left: 5,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularPercentIndicator(
                      center: new Text(
                        "${(progress * 100).toInt()}%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            color: MyTheme.dark_grey),
                      ),
                      radius: 30.0,
                      lineWidth: 10.0,
                      percent: progress,
                      backgroundColor: MyTheme.dark_grey,
                      progressColor: MyTheme.green,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('10 friends & neighbours',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.0,
                                color: Colors.black)),
                        SizedBox(
                          height: 5,
                        ),
                        Text('20 Groups',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.0,
                                color: Colors.black)),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Society: Pitlali 577511',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.0,
                                color: Colors.black)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            //KYC Section
            ExpandedTileWidget(
              controller: _controller1,
              title: 'KYC',
              children: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            '1. Adhaar Card',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          )),
                          (profileData!.kyc.aadhar.isNotEmpty)
                              ? Expanded(
                                  child: Text(
                                  profileData!.kyc.aadhar,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ))
                              : Expanded(
                                  child: Text(
                                  'Not Added',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            '2. PAN Card',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          )),
                          (profileData!.kyc.pan.isNotEmpty)
                              ? Expanded(
                                  child: Text(
                                  profileData!.kyc.pan,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ))
                              : Expanded(
                                  child: Text(
                                  'Not Added',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                            '3. GST',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          )),
                          (profileData!.kyc.gst.isNotEmpty)
                              ? Expanded(
                                  child: Text(
                                  profileData!.kyc.gst,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ))
                              : Expanded(
                                  child: Text(
                                  'Not Added',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            //Address Section
            ExpandedTileWidget(
              controller: _controller2,
              title: 'District, Taluk, Hobli, Village',
              children: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: (profileData!.address.length > 0)
                    ? Column(
                        children: List.generate(
                          profileData!.address.length,
                          (index) {
                            var item = profileData!.address[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${index + 1}. ${item.district}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(item.taluk,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(item.hobli,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(item.village,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                        )),
                                  ),
                                  // Expanded(child: Text(item.village)),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No Address Added',
                                style:
                                    TextStyle(fontSize: 13, color: Colors.red)),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            // ExpandedTileWidget(
            //   controller: _controller3,
            //   title: 'Village, Land Details',
            //   children: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            //     child: Column(
            //       children: [
            //         ExpandedTileWidget(
            //           controller: _controller35,
            //           title: 'Embedded',
            //           children: Column(
            //             children: [
            //               Text('Text inside embedded'),
            //             ],
            //           ),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Expanded(child: Text('1. Adhaar Card')),
            //             Expanded(child: Text('7848749257')),
            //             CircleAvatar(
            //               radius: 12,
            //               backgroundColor: MyTheme.green,
            //               child: Icon(
            //                 Icons.check,
            //                 size: 15.0,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(
            //           height: 3,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Expanded(child: Text('2. Pan Card')),
            //             Expanded(child: Text('DLFJF8248D')),
            //             Icon(
            //               Icons.upload_file_outlined,
            //               size: 23.0,
            //               color: MyTheme.green,
            //             ),
            //           ],
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Expanded(child: Text('3. GST Details')),
            //             Expanded(child: Text('HTFJF8245544148D')),
            //             Icon(
            //               Icons.upload_file_outlined,
            //               size: 23.0,
            //               color: MyTheme.green,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 15,
            // ),

            //Land Section
            InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                // Handle tap event here
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LandScreen();
                }));
              },
              child: IgnorePointer(
                ignoring: true,
                child: Ink(
                  child: ExpandedTileWidget(
                      controller: new ExpandedTileController(),
                      title: 'Land Details (Village, Syno, Plot size..)',
                      children: SizedBox.shrink()),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            //Crops Section
            ExpandedTileWidget(
              controller: _controller4,
              title: 'Crops Grown and Planned',
              children: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text('No Crops Added',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.red)),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Add them by going to Land Details',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            //Machines Section
            ExpandedTileWidget(
              controller: _controller4,
              title: 'Tractor, JCB, Tiller, Rotovotator',
              children: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('No Machines Added',
                        style: TextStyle(fontSize: 13, color: Colors.red)),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Add them by going to Land Details',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // RefreshIndicator buildBody() {
  //   return RefreshIndicator(
  //     color: MyTheme.white,
  //     backgroundColor: MyTheme.primary_color,
  // onRefresh: _onPageRefresh,
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
                Container(
                  width: 30,
                  child: Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return EditProfileScreen();
                        }));
                      },
                      child: Icon(
                        Icons.edit_square,
                        size: 20,
                        color: MyTheme.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.more_detail_ucf,
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
                        // // Navigator.push(context,
                        // //     MaterialPageRoute(builder: (context) {
                        // //   return Profile();
                        // // }));
                        // Navigator.popUntil(context, (route) {
                        //   // Check if the route is the Profile screen
                        //   return route.settings.name == '/profile';
                        // });
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
