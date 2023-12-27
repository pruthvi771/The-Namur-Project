// translation done.

import 'package:active_ecommerce_flutter/features/profile/address_list.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/expanded_tile_widget.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/features/profile/services/misc_bloc/misc_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_state.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/edit_profile.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/land_screen.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
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
    if (profileData.kyc.aadhar.isNotEmpty) {
      tempProgress += 0.2;
    }
    int cropCount = 0;

    for (Land land in profileData.land) {
      cropCount += land.crops.length;
    }

    if (cropCount > 0) {
      tempProgress += 0.2;
    }

    int machineCount = 0;

    for (Land land in profileData.land) {
      machineCount += land.equipments.length;
    }

    if (machineCount > 0) {
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
    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
    profileData = dataBox.get('profile');

    calculatingProgress(profileData);
  }

  Future<List<Object?>> getNumberOfFriends() async {
    var dataBox = Hive.box<ProfileData>('profileDataBox3');

    var savedData = dataBox.get('profile');
    if (savedData == null) {
      throw Exception('Failed to load data');
    }
    if (savedData.address[0].pincode.isEmpty) {
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
      if (data['profileData']['address'].isNotEmpty) {
        Map<String, dynamic> data = document.data()!;
        if (data['profileData']['address'][0]['pincode'] ==
            savedData.address[0].pincode) {
          count++;
          print('count incremented');
        }
      }
    }

    return [villageName, pincode, count - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 35,
            color: MyTheme.white,
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.settings_ucf,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditProfileScreen();
              }));
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<HiveBloc>(context).add(
            HiveDataRequested(),
          );
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
          profileData = dataBox.get('profile');
          setState(() {
            calculatingProgress(profileData);
          });
        },
        child: ListView(
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
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              if (state is ProfileDataReceived) {
                                return CircleAvatar(
                                  radius: 40,
                                  child: (state.buyerProfileData.photoURL ==
                                              null ||
                                          state.buyerProfileData.photoURL == '')
                                      ? ClipOval(
                                          child: Image.asset(
                                            "assets/default_profile2.png",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipOval(
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: CachedNetworkImage(
                                              imageUrl: state
                                                  .buyerProfileData.photoURL!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
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
                    child: BlocBuilder<MiscBloc, MiscState>(
                        builder: (context, state) {
                      if (state is MiscDataReceived) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${state.numberOfFriends} ${AppLocalizations.of(context)!.friends_and_neighbours}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.0,
                                    color: Colors.black)),
                            SizedBox(
                              height: 5,
                            ),
                            // Text(
                            //     '0 ${AppLocalizations.of(context)!.groups}',
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.w700,
                            //         fontSize: 13.0,
                            //         color: Colors.black)),
                            // SizedBox(
                            //   height: 5,
                            // ),
                            Text(
                                '${AppLocalizations.of(context)!.society}: ${state.villageName} ${state.pincode}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.0,
                                    color: Colors.black)),
                          ],
                        );
                      }
                      if (state is MiscLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Text(
                          AppLocalizations.of(context)!.add_address_to_see_this,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.0,
                              color: Colors.red));
                    }),
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
                                  AppLocalizations.of(context)!.not_added,
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
                                  AppLocalizations.of(context)!.not_added,
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
                                  AppLocalizations.of(context)!.not_added,
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
              title:
                  'Pincode, ${AppLocalizations.of(context)!.district}, ${AppLocalizations.of(context)!.gram_panchayat}, ${AppLocalizations.of(context)!.taluk}, ${AppLocalizations.of(context)!.village}',
              children: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: (profileData!.address.length > 0)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          profileData!.address.length,
                          (index) {
                            var item = profileData!.address[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 14),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          'Pincode',
                                          style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800),
                                        )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              item.pincode,
                                              style: TextStyle(
                                                fontSize: 13.5,
                                              ),
                                            )),
                                      ],
                                    ),
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
                                          AppLocalizations.of(context)!
                                              .district,
                                          style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800),
                                        )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              item.district,
                                              style: TextStyle(
                                                fontSize: 13.5,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
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
                                          AppLocalizations.of(context)!
                                              .gram_panchayat,
                                          style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800),
                                        )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              item.gramPanchayat,
                                              style: TextStyle(
                                                fontSize: 13.5,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
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
                                          AppLocalizations.of(context)!.village,
                                          style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800),
                                        )),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              item.village,
                                              style: TextStyle(
                                                fontSize: 13.5,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
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
                            child: Text(
                                AppLocalizations.of(context)!
                                    .no_address_is_added,
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
                      title: AppLocalizations.of(context)!
                          .land_details_syno_plot_size_ucf,
                      children: SizedBox.shrink()),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            //Crops Section

            //Machines Section
            BlocBuilder<HiveBloc, HiveState>(
              builder: (context, state) {
                if (state is HiveDataReceived) {
                  List machinesList = [];
                  List cropsList = [];
                  state.profileData.land.forEach((land) {
                    land.equipments.forEach((machine) {
                      machinesList.add(machine);
                    });
                    land.crops.forEach((crop) {
                      cropsList.add(crop.name);
                    });
                  });
                  return Column(
                    children: [
                      ExpandedTileWidget(
                          controller: _cropsController,
                          title: AppLocalizations.of(context)!
                              .crops_grown_and_planned,
                          children: (cropsList.length == 0)
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .no_crops_added,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.red)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .add_them_here,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height: 140,
                                  child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                      cropsList.length,
                                      (index) {
                                        var crop = cropsList[index];
                                        return EquipmentWidget(
                                          title: translatedName(
                                            name: crop.toString().toLowerCase(),
                                            context: context,
                                          ),
                                          image: imageForNameCloud[crop
                                                  .toString()
                                                  .toLowerCase()] ??
                                              imageForNameCloud['placeholder']!,
                                        );
                                      },
                                    ),
                                  ),
                                )),
                      SizedBox(
                        height: 15,
                      ),
                      ExpandedTileWidget(
                        controller: _machinesController,
                        title: AppLocalizations.of(context)!
                            .tractor_jcb_tiller_rotovator,
                        children: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: (machinesList.length == 0)
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .no_machines_added,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.red)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .add_them_here,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height: 140,
                                  child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                      machinesList.length,
                                      (index) {
                                        var machine = machinesList[index];
                                        return EquipmentWidget(
                                          title: translatedName(
                                            name: machine
                                                .toString()
                                                .toLowerCase(),
                                            context: context,
                                          ),
                                          image: imageForNameCloud[machine
                                                  .toString()
                                                  .toLowerCase()] ??
                                              imageForNameCloud['placeholder']!,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
