import 'package:active_ecommerce_flutter/features/profile/address_list.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/edit_profile.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../custom/device_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

// import '../seller_platform/seller_platform.dart';

class LandScreen extends StatefulWidget {
  const LandScreen({Key? key}) : super(key: key);

  @override
  State<LandScreen> createState() => _LandScreenState();
}

class _LandScreenState extends State<LandScreen> with TickerProviderStateMixin {
  // final _controller1 = ExpandedTileController();
  final _areaController = new ExpandedTileController(isExpanded: true);
  final _cropController = new ExpandedTileController(isExpanded: true);
  final _landController = new ExpandedTileController(isExpanded: true);

  String title = "KYC";
  final double progress = 0.80;
  late ProfileData? profileData;

  Future<ProfileData> fetchDataFromHive() async {
    var dataBox = await Hive.openBox<ProfileData>('profileDataBox3');
    return dataBox.get('profile') as ProfileData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: FutureBuilder(
          future: fetchDataFromHive(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: buildCustomAppBar(context),
                body: Center(
                  child: CircularProgressIndicator(
                    color: MyTheme.accent_color,
                  ),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              profileData = snapshot.data;
              TabController tabController =
                  TabController(length: profileData!.land.length, vsync: this);
              print(profileData!.land.length);
              if (profileData!.land.length == 0)
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: buildCustomAppBar(context),
                  body: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.no_land_added_yet,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .5,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyTheme.accent_color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.add_land_first,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return EditProfileScreen();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              return DefaultTabController(
                length: profileData!.land.length,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: buildCustomAppBar(context),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            height: 50,
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
                              controller: tabController,
                              isScrollable: true,
                              labelPadding:
                                  EdgeInsets.symmetric(horizontal: 25),
                              tabs: List.generate(
                                profileData!.land.length,
                                (index) {
                                  var item = profileData!.land[index];
                                  return Tab(
                                    child: Text(
                                      item.village,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: List.generate(
                            profileData!.land.length,
                            (index) {
                              var item = profileData!.land[index];
                              // print('crops: ${item.crops.length}');
                              // print('machines: ${item.equipments.length}');
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(bottom: 20),
                                physics: BouncingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      LandExpandedTile(
                                        controller2: _areaController,
                                        title: AppLocalizations.of(context)!
                                            .land_details,
                                        content: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 8),
                                          height: 150,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: double.infinity,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                    child: Image.asset(
                                                      'assets/farmland_medium.jpeg',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        MyTheme.green_lighter,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .size_in_acres,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: .5,
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      Text(
                                                        '${item.area.toInt()}',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: .5,
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      Text(
                                                        'Sy No.',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: .5,
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                      Text(
                                                        item.syno,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: .5,
                                                            fontFamily:
                                                                'Poppins'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      LandExpandedTile(
                                          controller2: _cropController,
                                          title: AppLocalizations.of(context)!
                                              .crops,
                                          content: (item.crops.length != 0)
                                              ? Container(
                                                  height: 150,
                                                  child: ListView(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: List.generate(
                                                      item.crops.length,
                                                      (index) {
                                                        var crop =
                                                            item.crops[index];
                                                        return CropWidget(
                                                          title: translatedName(
                                                              name: crop.name
                                                                  .toString()
                                                                  .toLowerCase(),
                                                              context: context),
                                                          image: imageForNameCloud[crop
                                                                  .name
                                                                  .toLowerCase()] ??
                                                              imageForNameCloud[
                                                                  'placeholder']!,
                                                          yieldOfCrop:
                                                              crop.yieldOfCrop,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: 50,
                                                  child: Center(
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .no_crops_added,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: .5,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      LandExpandedTile(
                                        controller2: _landController,
                                        title: AppLocalizations.of(context)!
                                            .machine,
                                        content: (item.equipments.length != 0)
                                            ? Container(
                                                // padding: const EdgeInsets.symmetric(
                                                //     horizontal: 12),
                                                height: 140,
                                                child: ListView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: List.generate(
                                                    item.equipments.length,
                                                    (index) {
                                                      var equipment = item
                                                          .equipments[index];
                                                      return EquipmentWidget(
                                                        title: translatedName(
                                                            name: equipment
                                                                .toString()
                                                                .toLowerCase(),
                                                            context: context),
                                                        image: imageForNameCloud[
                                                                equipment
                                                                    .toLowerCase()] ??
                                                            imageForNameCloud[
                                                                'placeholder']!,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .no_machines_added,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: .5,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: buildCustomAppBar(context),
              body: Center(
                child: CircularProgressIndicator(
                  color: MyTheme.accent_color,
                ),
              ),
            );
          }),
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
                  child: Text(AppLocalizations.of(context)!.land,
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
        content: content,
      ),
    );
  }
}

class CropWidget extends StatelessWidget {
  const CropWidget({
    super.key,
    required this.image,
    required this.title,
    required this.yieldOfCrop,
  });

  final String image;
  final String title;
  final double yieldOfCrop;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 90,
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black12,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                fontFamily: 'Poppins',
              )),
          Text('${yieldOfCrop.toInt().toString()} ton'),
        ],
      ),
    );
  }
}

class EquipmentWidget extends StatelessWidget {
  const EquipmentWidget({
    super.key,
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 90,
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black12,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                fontFamily: 'Poppins',
              )),
        ],
      ),
    );
  }
}
