import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/expanded_tile_widget.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/edit_profile.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/land_screen.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import '../../../custom/device_info.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MoreDetails extends StatefulWidget {
  const MoreDetails({Key? key}) : super(key: key);

  @override
  State<MoreDetails> createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  final _kycController = ExpandedTileController(isExpanded: true);
  final _addressController = new ExpandedTileController(isExpanded: true);
  // final _landDetailsController = new ExpandedTileController();
  final _cropsController = new ExpandedTileController(isExpanded: true);
  final _machinesController = new ExpandedTileController(isExpanded: true);

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
    // if (!profileData.kyc.pan.isEmpty) {
    //   tempProgress += 0.2;
    // }
    // if (!profileData.kyc.gst.isEmpty) {
    //   tempProgress += 0.2;
    // }
    if (!(profileData.land.length == 0)) {
      tempProgress += 0.2;
    }

    progress = tempProgress;
  }

  @override
  void initState() {
    super.initState();
    _buyerUserDataFuture = _getUserData();
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

  late Future<BuyerData> _buyerUserDataFuture;

  Future<BuyerData> _getUserData() async {
    AuthUser user = AuthRepository().currentUser!;
    return FirestoreRepository().getBuyerData(userId: user.userId);
  }

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
        body: FutureBuilder(
            future: _buyerUserDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                BuyerData buyerUserData = snapshot.data as BuyerData;
                return ListView(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
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
                                  child: CircleAvatar(
                                    radius: 40,
                                    child: (buyerUserData.photoURL == null ||
                                            buyerUserData.photoURL == '')
                                        ? ClipOval(
                                            child: Image.asset(
                                              "assets/default_profile2.png",
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipOval(
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Image.network(
                                                buyerUserData.photoURL!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
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
                      controller: _kycController,
                      title: 'KYC',
                      children: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 7, right: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              padding: const EdgeInsets.only(
                                  top: 5, left: 7, right: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              padding: const EdgeInsets.only(
                                  top: 5, left: 7, right: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                      controller: _addressController,
                      title: 'District, Taluk, Hobli, Village',
                      children: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
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
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.red)),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    //Land Section
                    InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        // Handle tap event here
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LandScreen();
                        }));
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: Ink(
                          child: ExpandedTileWidget(
                              controller: new ExpandedTileController(),
                              title:
                                  'Land Details (Village, Syno, Plot size..)',
                              children: SizedBox.shrink()),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    //Crops Section
                    ExpandedTileWidget(
                      controller: _cropsController,
                      title: 'Crops Grown and Planned',
                      children: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text('No Crops Added',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.red)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Add them by going to Land Details',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600])),
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
                      controller: _machinesController,
                      title: 'Tractor, JCB, Tiller, Rotovotator',
                      children: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text('No Machines Added',
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
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 0),
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
                  child: Text(AppLocalizations.of(context)!.more_detail_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  width: 30,
                  height: double.infinity,
                  child: InkWell(
                    //padding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return EditProfileScreen();
                      }));
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .5,
                            fontFamily: 'Poppins'),
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
