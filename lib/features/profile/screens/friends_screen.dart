import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/models/seller_group_item.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/services/friends_bloc/friends_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/misc_bloc/misc_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/utils/functions.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final double progress = 0.80;
  late final AuthUser currentUser;
  FirestoreRepository firestoreRepository = FirestoreRepository();
  late Future<SellerDataForFriendsScreen> _sellerUserDataFuture;
  late Future<List<String>?> _getSubCategoryListFuture;
  int selectedGroupIndex = 0;
  int indexForSellers = 0;
  var imageLinks = imageForNameCloud;
  LocationFilterType locationFilterType = LocationFilterType.village;

  Address? userAddress;

  List<String> locationTypeString = [
    'district',
    'taluk',
    'gramPanchayat',
    'village',
  ];

  late Map<String, String> locationTypeStringMap;

  String? locationTypeStringSelected = 'village';

  @override
  void initState() {
    userAddress = getUserLocationFromHive();
    if (userAddress == null) {
      super.initState();
      return;
    }
    locationTypeStringMap = {
      'district': userAddress!.district,
      'taluk': userAddress!.taluk,
      'gramPanchayat': userAddress!.gramPanchayat,
      'village': userAddress!.village,
    };
    currentUser = AuthRepository().currentUser!;
    _sellerUserDataFuture = _getSellerUserData();
    _getSubCategoryListFuture = getSubCategoryList(productIDs: null);
    super.initState();
  }

  Future<SellerDataForFriendsScreen> _getSellerUserData() async {
    AuthUser user = AuthRepository().currentUser!;
    return firestoreRepository.getSellerData(userId: user.userId);
  }

  Future<List<String>?> getSubCategoryList({required List? productIDs}) async {
    if (productIDs == null) {
      return null;
    }

    List<String> categoryList = [];

    void addItemToCategoryList({required String? item}) {
      if (item == null) {
        return;
      }
      if (!categoryList.contains(item)) {
        categoryList.add(item);
        //
      }
    }

    for (var product in productIDs) {
      var categoryName =
          await firestoreRepository.getSubCategoryName(productId: product);

      addItemToCategoryList(item: categoryName);
    }

    return categoryList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.friends,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: MyTheme.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: userAddress == null
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.add_address_to_see_this,
                style: TextStyle(fontSize: 17, color: Colors.black45),
              ),
            )
          : FutureBuilder(
              future: _sellerUserDataFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var sellerData = snapshot.data as SellerDataForFriendsScreen;
                  _getSubCategoryListFuture =
                      getSubCategoryList(productIDs: sellerData.products);

                  return ListView(
                    padding: EdgeInsets.all(8),
                    physics: BouncingScrollPhysics(),
                    children: [
                      // Top Bar
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
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: null,
                                            ),
                                            child: ClipOval(
                                              child: (sellerData.photoURL ==
                                                          null ||
                                                      sellerData.photoURL == '')
                                                  ? Image.asset(
                                                      "assets/default_profile2.png",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: sellerData
                                                              .photoURL ??
                                                          imageForNameCloud[
                                                              'placeholder']!,
                                                      fit: BoxFit.cover,
                                                    ),
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
                                child: BlocBuilder<MiscBloc, MiscState>(
                                    builder: (context, state) {
                                  if (state is MiscDataReceived) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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

                      // Group Widgets
                      FutureBuilder(
                          future: _getSubCategoryListFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              var categoryList = snapshot.data;
                              if (categoryList == null ||
                                  categoryList.isEmpty) {
                                return Container(
                                  height: 200,
                                  // color: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .add_products_to_see_this_screen,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.4,
                                        ),
                                      )),
                                );
                              }

                              BlocProvider.of<FriendsBloc>(context).add(
                                FriendsRequested(
                                  subCategory: categoryList[indexForSellers],
                                  locationFilterType: locationFilterType,
                                  userAddress: userAddress!,
                                ),
                                // HiveAppendAddress(context: context),
                              );
                              return Column(
                                children: [
                                  // Groups Text
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          AppLocalizations.of(context)!.groups,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: .5,
                                            fontFamily: 'Poppins',
                                            decoration:
                                                TextDecoration.underline,
                                          )),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Container(
                                      height: 115,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: categoryList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedGroupIndex = index;
                                                indexForSellers = index;
                                              });
                                            },
                                            child: GroupWidget2(
                                              title: categoryList[index],
                                              // name: 'hello',
                                              image: imageLinks[
                                                      categoryList[index]
                                                          .toLowerCase()] ??
                                                  imageLinks['placeholder']!,
                                              isSelected:
                                                  selectedGroupIndex == index
                                                      ? true
                                                      : false,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  // People in your area text
                                  Container(
                                    height: 50,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .people_in_your_area,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: .5,
                                                fontFamily: 'Poppins',
                                                decoration:
                                                    TextDecoration.underline,
                                              )),
                                        ),
                                        Expanded(
                                          child: DropdownButtonWidget(
                                              '',
                                              AppLocalizations.of(context)!
                                                  .group_by,
                                              locationTypeString.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                      locationTypeStringMap[
                                                          value]!),
                                                );
                                              }).toList(),
                                              locationTypeStringSelected,
                                              (value) {
                                            setState(
                                              () {
                                                locationTypeStringSelected =
                                                    value;
                                                if (value == 'district') {
                                                  locationFilterType =
                                                      LocationFilterType
                                                          .district;
                                                } else if (value == 'taluk') {
                                                  locationFilterType =
                                                      LocationFilterType.taluk;
                                                } else if (value ==
                                                    'gramPanchayat') {
                                                  locationFilterType =
                                                      LocationFilterType
                                                          .gramPanchayat;
                                                } else if (value == 'village') {
                                                  locationFilterType =
                                                      LocationFilterType
                                                          .village;
                                                }
                                                BlocProvider.of<FriendsBloc>(
                                                        context)
                                                    .add(
                                                  FriendsRequested(
                                                    subCategory: categoryList[
                                                        indexForSellers],
                                                    locationFilterType:
                                                        locationFilterType,
                                                    userAddress: userAddress!,
                                                  ),
                                                  // HiveAppendAddress(context: context),
                                                );
                                              },
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  BlocBuilder<FriendsBloc, FriendsState>(
                                      builder: (context, state) {
                                    if (state is FriendsLoadInProgress) {
                                      return Container(
                                        height: 200,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          color: MyTheme.primary_color,
                                        )),
                                      );
                                    }
                                    if (state is FriendsLoadSuccess) {
                                      List<SellerGroupItem> sellersList =
                                          state.sellers;
                                      sellersList.removeWhere((item) =>
                                          item.sellerId == currentUser.userId);
                                      return sellersList.isEmpty
                                          ? Container(
                                              height: 200,
                                              // color: Colors.red,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .there_are_no_people_in_this_group,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.4,
                                                    ),
                                                  )))
                                          : MasonryGridView.count(
                                              crossAxisCount: 4,
                                              mainAxisSpacing: 4,
                                              crossAxisSpacing: 4,
                                              itemCount: sellersList.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.all(4),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                //
                                                return GestureDetector(
                                                  onTap: () {
                                                    print(sellersList[index]
                                                        .phoneNumber);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    left: 10,
                                                                    right: 10),
                                                            actionsPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            buttonPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            content: Container(
                                                              height: 300,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child: CachedNetworkImage(
                                                                          imageUrl: sellersList[index]
                                                                              .imageURL,
                                                                          fit: BoxFit
                                                                              .cover),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        sellersList[index]
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            10),
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.1),
                                                                    width: double
                                                                        .infinity,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          sellersList[index]
                                                                              .phoneNumber,
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                        IconButton(
                                                                          icon:
                                                                              FaIcon(
                                                                            FontAwesomeIcons.whatsapp,
                                                                            color: sellersList[index].phoneNumber.isEmpty
                                                                                ? Colors.grey
                                                                                : Colors.green,
                                                                            size:
                                                                                30,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            if (sellersList[index].phoneNumber.isEmpty) {
                                                                              return;
                                                                            }
                                                                            openWhatsAppChat(sellersList[index].phoneNumber);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(AppLocalizations.of(
                                                                          context)!
                                                                      .dismiss)),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: ClipOval(
                                                    child: Container(
                                                      child: Stack(
                                                        children: [
                                                          AspectRatio(
                                                            aspectRatio: 1 / 1,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  sellersList[
                                                                          index]
                                                                      .imageURL,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                    }

                                    return Container(
                                      height: 200,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: MyTheme.primary_color,
                                      )),
                                    );
                                  }),
                                ],
                              );
                            }
                            if (snapshot.hasError) {
                              return Container(
                                height: 200,
                                // color: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .something_went_wrong,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              height: 200,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: MyTheme.primary_color,
                              )),
                            );
                          }),

                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
    );
  }

  Container DropdownButtonWidget(
      String title,
      String hintText,
      List<DropdownMenuItem<String>>? itemList,
      String? dropdownValue,
      Function(String) onChanged) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey, // You can customize the border color here
        ),
      ),
      child: DropdownButton<String>(
        hint: Text(
          hintText,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        isExpanded: true,
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        underline: SizedBox(),
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        onChanged: (String? value) {
          onChanged(value!);
        },
        items: itemList,
      ),
    );
  }
}

class GroupWidget extends StatelessWidget {
  const GroupWidget({
    super.key,
    required this.name,
    required this.image,
    required this.isSelected,
  });

  final String name;
  final String image;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        // height: 100,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          // color: Colors.red[200],
          border: isSelected
              ? Border.all(
                  color: Colors.black
                      .withOpacity(0.1), // You can set the border color here
                  width: 3.0, // You can set the border width here
                )
              : null,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupWidget2 extends StatelessWidget {
  const GroupWidget2({
    super.key,
    required this.image,
    required this.title,
    required this.isSelected,
  });

  final String image;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      width: 80,
      margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.black87 : Colors.black12,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: .5,
                fontFamily: 'Poppins',
              )),
        ],
      ),
    );
  }
}
