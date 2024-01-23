// translation done.

import 'dart:async';
import 'dart:typed_data';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/features/calendar/screens/calendar_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/address_list.dart';
import 'package:active_ecommerce_flutter/features/profile/enum.dart';
import 'package:active_ecommerce_flutter/features/profile/models/updates_data.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/friends_screen.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_state.dart';
import 'package:active_ecommerce_flutter/features/profile/services/misc_bloc/misc_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/hive_machine_details.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/more_details.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_event.dart';
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_state.dart';
import 'package:active_ecommerce_flutter/features/profile/utils.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  HomePresenter homeData = HomePresenter();
  ScrollController _mainScrollController = ScrollController();
  late BuildContext loadingcontext;

  ProfileSection _profileSection = ProfileSection.updates;
  late Future<List<UpdatesData>> updatesDataFuture;
  late Future<List<CropCalendarItem>> cropCalendarDataFuture;

  var imageLinks = imageForNameCloud;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(
      ProfileDataRequested(),
    );
    BlocProvider.of<HiveBloc>(context).add(
      HiveDataRequested(),
    );
    updatesDataFuture = getUpdatesDate();
    cropCalendarDataFuture = getCropCalendarData();
  }

  Future<List<UpdatesData>> getUpdatesDate() async {
    List<UpdatesData> updatesData = [];

    var userSnapshot =
        await FirebaseFirestore.instance.collection('updates').get();

    for (var document in userSnapshot.docs) {
      // userSnapshot.docs[0].data()!['imageURL']
      updatesData.add(UpdatesData(
        imageURL: document.data()['imageURL'],
        goToURL: document.data()['link'],
      ));
    }

    return updatesData;
  }

  Future<List<CropCalendarItem>> getCropCalendarData() async {
    List<CropCalendarItem> cropCalendarData = [];

    var dataBox = Hive.box<CropCalendarData>('cropCalendarDataBox');
    var savedData = dataBox.get('calendar');

    if (savedData == null) {
      return [];
    }

    for (CropCalendarItem crop in savedData.cropCalendarItems) {
      cropCalendarData.add(crop);
    }

    return cropCalendarData;
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  selectImage(ImageSource source) async {
    Uint8List img = await pickImage(source);
    _image = img;
  }

  saveProfileImage() async {
    ImageSource? source;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            content: Container(
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.choose_image_from,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              source = ImageSource.camera;
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: MyTheme.green_lighter.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: MyTheme.green),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: MyTheme.primary_color,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                        color: MyTheme.primary_color,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              source = ImageSource.gallery;
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: MyTheme.green_lighter.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: MyTheme.green),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: MyTheme.primary_color,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                        color: MyTheme.primary_color,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.dismiss)),
            ],
          );
        });
    if (source == null) {
      return;
    }
    await selectImage(source!);
    BlocProvider.of<ProfileBloc>(context).add(
      ProfileImageUpdateRequested(file: _image!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: buildView(context, _profileSection),
      ),
    );
  }

  Widget buildView(context, _profileSection) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: MyTheme.primary_color,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: MyTheme.white,
            ),
          ),
          drawer: const MainDrawer(),
          appBar: AppBar(
            // leading: IconButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   icon: Icon(
            //     Icons.keyboard_arrow_left,
            //     size: 35,
            //     color: MyTheme.white,
            //   ),
            // ),
            // automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff107B28), Color(0xff4C7B10)]),
              ),
            ),
            title: Text(AppLocalizations.of(context)!.profile_ucf,
                style: TextStyle(
                    color: MyTheme.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins')),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MoreDetails();
                  }));
                },
                icon: Icon(
                  Icons.settings,
                  // size: 35,
                  color: MyTheme.white,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: RefreshIndicator(
            child: buildBodyChildren(_profileSection),
            onRefresh: () async {
              BlocProvider.of<ProfileBloc>(context).add(
                ProfileDataRequested(),
              );
              BlocProvider.of<HiveBloc>(context).add(
                HiveDataRequested(),
              );
              updatesDataFuture = getUpdatesDate();
              cropCalendarDataFuture = getCropCalendarData();
            },
          ),
        ),
      ],
    );
  }

  CustomScrollView buildBodyChildren(profileSection) {
    _launchYouTubeVideo(url) async {
      final Uri _url = Uri.parse(url);
      if (await canLaunchUrl(_url)) {
        await launchUrl(_url);
      } else {
        throw 'Could not launch';
      }
    }

    return CustomScrollView(
      controller: _mainScrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileDataNotReceived) {
              ToastComponent.showDialog(
                  AppLocalizations.of(context)!.could_not_fetch_data_try_again,
                  gravity: Toast.center,
                  duration: Toast.lengthLong);
              Navigator.pop(context);
              return;
            }
            if (state is ProfileDataReceived) {}
          },
          child:
              BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state is ProfileDataReceived) {
              BuyerData buyerUserData = state.buyerProfileData;
              TabController tabController =
                  TabController(length: 2, vsync: this);
              return SliverList(
                delegate: SliverChildListDelegate([
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: (buyerUserData.photoURL == null ||
                                buyerUserData.photoURL == '')
                            ? Image.asset(
                                "assets/default_profile2.png",
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: buyerUserData.photoURL!,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5, right: 10),
                          child: InkWell(
                            onTap: () {
                              saveProfileImage();
                            },
                            child: Container(
                                padding: EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  //Profile Name
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Text(
                      buyerUserData.name,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins"),
                    ),
                  ),

                  // CircleAvatar, Region, Friends and Neighbors texts
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Friends();
                      }));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      height: 75,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyTheme.green_lighter.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 130,
                            child: Stack(
                              children: [
                                for (var i = 0; i < [1, 2].length; i++)
                                  Positioned(
                                    left: (i * (1 - .4) * 40).toDouble(),
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.transparent,
                                      // Set the background color to transparent
                                      child: CachedNetworkImage(
                                        imageUrl: imageForNameCloud['farmers']!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          return Container(
                                            height: 50,
                                            width: 50,
                                            child: Center(
                                                child:
                                                    LinearProgressIndicator()),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: BlocBuilder<MiscBloc, MiscState>(
                                builder: (context, state) {
                              if (state is MiscDataReceived) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      //Region text
                                      Text('${state.villageName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.black)),
                                      Text('${state.pincode}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.black)),

                                      //Friends and Neighbors text
                                      Text(
                                        '${state.numberOfFriends} ${AppLocalizations.of(context)!.friends_and_neighbours}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Text(
                                AppLocalizations.of(context)!
                                    .add_address_to_see_this,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.red),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),

                  // tabs
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
                            controller: tabController,
                            labelPadding: EdgeInsets.symmetric(horizontal: 25),
                            tabs: [
                              Tab(
                                child: Text(
                                  AppLocalizations.of(context)!.updates,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  AppLocalizations.of(context)!.my_stock,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height - 300,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        FutureBuilder(
                            future: updatesDataFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                List<UpdatesData> updatesList = snapshot.data!;
                                return updatesList.length == 0
                                    ? Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .no_data_is_available,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins'),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: updatesList.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await _launchYouTubeVideo(
                                                            updatesList[index]
                                                                .goToURL);
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            updatesList[index]
                                                                .imageURL,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                        FutureBuilder(
                          future: cropCalendarDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasData && snapshot.data != null) {
                              //
                              return BlocBuilder<HiveBloc, HiveState>(
                                builder: (context, state) {
                                  if (state is HiveDataReceived) {
                                    List<CropProfileDisplay> cropsToDisplay =
                                        [];

                                    for (Land currentLand
                                        in state.profileData.land) {
                                      for (Crop currentCrop
                                          in currentLand.crops) {
                                        CropCalendarItem?
                                            currentCropCalendarItem;

                                        for (CropCalendarItem cropCalendarItem
                                            in snapshot.data!) {
                                          if (cropCalendarItem.cropName ==
                                                  currentCrop.name &&
                                              cropCalendarItem.landSyno ==
                                                  currentLand.syno) {
                                            currentCropCalendarItem =
                                                cropCalendarItem;
                                            break;
                                          }
                                        }

                                        cropsToDisplay.add(
                                          CropProfileDisplay(
                                            cropName: currentCrop.name,
                                            landSyno: currentLand.syno,
                                            yieldOfCrop:
                                                currentCrop.yieldOfCrop,
                                            beingTracked:
                                                currentCropCalendarItem != null,
                                            plantingDate:
                                                currentCropCalendarItem != null
                                                    ? currentCropCalendarItem
                                                        .plantingDate
                                                    : null,
                                          ),
                                        );
                                      }
                                    }
                                    return SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18),
                                        child: Column(
                                          children: [
                                            // crops
                                            Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .crops
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                                cropsToDisplay.length == 0
                                                    ? Container(
                                                        height: 100,
                                                        child: Center(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .no_data_is_available,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Poppins'),
                                                          ),
                                                        ),
                                                      )
                                                    : MasonryGridView.count(
                                                        crossAxisCount: 3,
                                                        mainAxisSpacing: 16,
                                                        crossAxisSpacing: 16,
                                                        itemCount:
                                                            cropsToDisplay
                                                                .length,
                                                        shrinkWrap: true,
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (dialogContext) {
                                                                    return AlertDialog(
                                                                      contentPadding: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                      actionsPadding:
                                                                          EdgeInsets.all(
                                                                              0),
                                                                      buttonPadding:
                                                                          EdgeInsets.all(
                                                                              0),
                                                                      content:
                                                                          Container(
                                                                        height:
                                                                            330,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                child: CachedNetworkImage(imageUrl: imageLinks[cropsToDisplay[index].cropName.toLowerCase()] ?? imageLinks['placeholder']!, fit: BoxFit.fitHeight),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  // cropsToDisplay[index].cropName,
                                                                                  translatedName(
                                                                                    name: cropsToDisplay[index].cropName.toLowerCase(),
                                                                                    context: context,
                                                                                  ),
                                                                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                              color: Colors.grey.withOpacity(0.1),
                                                                              width: double.infinity,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    '${AppLocalizations.of(context)!.yield}: ${cropsToDisplay[index].yieldOfCrop.toString()}',
                                                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                              color: Colors.grey.withOpacity(0.1),
                                                                              width: double.infinity,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    '${AppLocalizations.of(dialogContext)!.land} Syno: ${cropsToDisplay[index].landSyno}',
                                                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                              color: Colors.grey.withOpacity(0.1),
                                                                              width: double.infinity,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    '${AppLocalizations.of(dialogContext)!.planting_date}: ${cropsToDisplay[index].beingTracked ? cropsToDisplay[index].plantingDate!.day.toString() + '/' + cropsToDisplay[index].plantingDate!.month.toString() + '/' + cropsToDisplay[index].plantingDate!.year.toString() : AppLocalizations.of(dialogContext)!.not_tracked}',
                                                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              TextButton(
                                                                                  onPressed: cropsToDisplay[index].beingTracked
                                                                                      ? () {
                                                                                          Navigator.pop(dialogContext);
                                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                            return CalendarScreen();
                                                                                          }));
                                                                                        }
                                                                                      : null,
                                                                                  child: Text(AppLocalizations.of(dialogContext)!.go_to_crop_calendar)),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(dialogContext);
                                                                                  },
                                                                                  child: Text(AppLocalizations.of(dialogContext)!.dismiss)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: MyTheme
                                                                    .green_lighter
                                                                    .withOpacity(
                                                                        0.2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                        bottom:
                                                                            8),
                                                                    height: 50,
                                                                    width: 50,
                                                                    child: CachedNetworkImage(
                                                                        imageUrl:
                                                                            imageLinks[cropsToDisplay[index].cropName.toLowerCase()] ??
                                                                                imageLinks['placeholder']!),
                                                                  ),
                                                                  Text(
                                                                    translatedName(
                                                                      name: cropsToDisplay[
                                                                              index]
                                                                          .cropName
                                                                          .toLowerCase(),
                                                                      context:
                                                                          context,
                                                                    ),
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            // machines
                                            Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .machine
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                                state.profileData.land.length ==
                                                        0
                                                    ? Container(
                                                        height: 100,
                                                        child: Center(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .no_data_is_available,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Poppins'),
                                                          ),
                                                        ),
                                                      )
                                                    : Column(
                                                        children: List.generate(
                                                          state.profileData.land
                                                              .length,
                                                          (landIndex) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    state
                                                                            .profileData
                                                                            .land[landIndex]
                                                                            .village +
                                                                        ' (${state.profileData.land[landIndex].syno})',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                                state
                                                                            .profileData
                                                                            .land[
                                                                                landIndex]
                                                                            .equipments
                                                                            .length ==
                                                                        0
                                                                    ? Container(
                                                                        height:
                                                                            100,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            AppLocalizations.of(context)!.no_data_is_available,
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: 'Poppins'),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : MasonryGridView
                                                                        .count(
                                                                        crossAxisCount:
                                                                            3,
                                                                        mainAxisSpacing:
                                                                            16,
                                                                        crossAxisSpacing:
                                                                            16,
                                                                        itemCount: state
                                                                            .profileData
                                                                            .land[landIndex]
                                                                            .equipments
                                                                            .length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        padding:
                                                                            EdgeInsets.only(top: 15),
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        itemBuilder:
                                                                            (context,
                                                                                machineIndex) {
                                                                          String machine = state
                                                                              .profileData
                                                                              .land[landIndex]
                                                                              .equipments[machineIndex];
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                                return HiveMachineDetails(
                                                                                  machineName: machine,
                                                                                  landSynoValue: state.profileData.land[landIndex].syno,
                                                                                );
                                                                              }));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.symmetric(vertical: 8),
                                                                              decoration: BoxDecoration(
                                                                                color: MyTheme.green_lighter.withOpacity(0.2),
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
                                                                              child: Column(
                                                                                children: [
                                                                                  Container(
                                                                                    margin: EdgeInsets.only(top: 8.0, bottom: 8),
                                                                                    height: 50,
                                                                                    width: 50,
                                                                                    child: CachedNetworkImage(imageUrl: imageLinks[machine.toLowerCase()] ?? imageLinks['placeholder']!),
                                                                                  ),
                                                                                  Text(
                                                                                    // machine,
                                                                                    translatedName(
                                                                                      name: machine.toLowerCase(),
                                                                                      context: context,
                                                                                    ),
                                                                                    maxLines: 1,
                                                                                    textAlign: TextAlign.center,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 15,
                                            ),

                                            // animals
                                            Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .animal
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                                state.profileData.land.length ==
                                                        0
                                                    ? Container(
                                                        height: 100,
                                                        child: Center(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .no_data_is_available,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Poppins'),
                                                          ),
                                                        ),
                                                      )
                                                    : Column(
                                                        children: List.generate(
                                                          state.profileData.land
                                                              .length,
                                                          (landIndex) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    state
                                                                            .profileData
                                                                            .land[landIndex]
                                                                            .village +
                                                                        ' (${state.profileData.land[landIndex].syno})',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                                state
                                                                            .profileData
                                                                            .land[
                                                                                landIndex]
                                                                            .animals
                                                                            .length ==
                                                                        0
                                                                    ? Container(
                                                                        height:
                                                                            100,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            AppLocalizations.of(context)!.no_data_is_available,
                                                                            style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: 'Poppins'),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : MasonryGridView
                                                                        .count(
                                                                        crossAxisCount:
                                                                            3,
                                                                        mainAxisSpacing:
                                                                            16,
                                                                        crossAxisSpacing:
                                                                            16,
                                                                        itemCount: state
                                                                            .profileData
                                                                            .land[landIndex]
                                                                            .animals
                                                                            .length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        padding:
                                                                            EdgeInsets.only(top: 15),
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        itemBuilder:
                                                                            (context,
                                                                                animalIndex) {
                                                                          String animal = state
                                                                              .profileData
                                                                              .land[landIndex]
                                                                              .animals[animalIndex]
                                                                              .name;
                                                                          return Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 8),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: MyTheme.green_lighter.withOpacity(0.2),
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  margin: EdgeInsets.only(top: 8.0, bottom: 8),
                                                                                  height: 50,
                                                                                  width: 50,
                                                                                  child: CachedNetworkImage(imageUrl: imageLinks[animal.toLowerCase()] ?? imageLinks['placeholder']!),
                                                                                ),
                                                                                Text(
                                                                                  // machine,
                                                                                  translatedName(
                                                                                    name: animal.toLowerCase(),
                                                                                    context: context,
                                                                                  ),
                                                                                  maxLines: 1,
                                                                                  textAlign: TextAlign.center,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .no_data_is_available,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  );
                                },
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
                ]),
              );
            }
            return SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: DeviceInfo(context).height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ]),
            );
          }),
        ),
      ],
    );
  }
}

class CropProfileDisplay {
  final String cropName;
  final String landSyno;
  final bool beingTracked;
  final DateTime? plantingDate;
  final double yieldOfCrop;

  CropProfileDisplay({
    required this.cropName,
    required this.landSyno,
    this.plantingDate,
    required this.yieldOfCrop,
    required this.beingTracked,
  });
}
