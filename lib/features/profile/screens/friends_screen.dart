import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/models/seller_group_item.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/utils/functions.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import '../../../custom/device_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import '../seller_platform/seller_platform.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  void initState() {
    currentUser = AuthRepository().currentUser!;
    _sellerUserDataFuture = _getSellerUserData();
    _getSubCategoryListFuture = getSubCategoryList(productIDs: null);
    _getOtherSellersFuture = getOtherSellers(subCategory: null);
    super.initState();
  }

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

  final double progress = 0.80;

  late final AuthUser currentUser;

  FirestoreRepository firestoreRepository = FirestoreRepository();

  final String image = "assets/onion.png";
  late Future<SellerDataForFriendsScreen> _sellerUserDataFuture;

  Future<SellerDataForFriendsScreen> _getSellerUserData() async {
    AuthUser user = AuthRepository().currentUser!;
    return firestoreRepository.getSellerData(userId: user.userId);
  }

  late Future<List<String>?> _getSubCategoryListFuture;

  Future<List<String>?> getSubCategoryList({required List? productIDs}) async {
    if (productIDs == null) {
      return null;
    }

    List<String> categoryList = [];

    void addItemToCategoryList(String item) {
      if (!categoryList.contains(item)) {
        categoryList.add(item);
        // print('Item "$item" added successfully.');
      }
    }

    for (var product in productIDs) {
      var categoryName =
          await firestoreRepository.getSubCategoryName(productId: product);

      addItemToCategoryList(categoryName!);
    }

    return categoryList;
  }

  late Future<List<SellerGroupItem>?> _getOtherSellersFuture;

  Future<List<SellerGroupItem>?> getOtherSellers(
      {required String? subCategory}) async {
    if (subCategory == null) {
      return null;
    }

    List<SellerGroupItem>? sellers = await firestoreRepository
        .getOtherSellersForSubCategory(subCategory: subCategory);
    // setState(() {
    //   loading = false;
    // });
    return sellers;
  }

  // Set<String> categoryListSet = {};

  int selectedGroupIndex = 0;
  // String selectedGroupSubCategory = "";

  // bool loading = true;
  int indexForSellers = 0;

  var imageLinks = imageForNameCloud;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildCustomAppBar(context),
        body: FutureBuilder(
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
                    // Text(sellerData.name),
                    // Text(sellerData.products.length.toString()),

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
                                          width:
                                              80, // Set your desired width for the circular avatar
                                          height: 80, //=
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
                                                    imageUrl:
                                                        sellerData.photoURL!,
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
                              // TODO: localizations, group number and beyond
                              child: FutureBuilder(
                                  future: getNumberOfFriends(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              '${AppLocalizations.of(context)!.society}: ${snapshot.data![0]} ${snapshot.data![1]}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.0,
                                                  color: Colors.black)),
                                        ],
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Text(
                                        AppLocalizations.of(context)!
                                            .add_address_to_see_this,
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

                    // Group Widgets
                    FutureBuilder(
                        future: _getSubCategoryListFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            var categoryList = snapshot.data;
                            if (categoryList == null || categoryList.isEmpty) {
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
                            _getOtherSellersFuture = getOtherSellers(
                                subCategory: categoryList[indexForSellers]);
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
                                          decoration: TextDecoration.underline,
                                        )),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
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
                                          // TODO: Add image
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
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .people_in_your_area,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: .5,
                                          fontFamily: 'Poppins',
                                          decoration: TextDecoration.underline,
                                        )),
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                // showing sellers
                                FutureBuilder(
                                    future: _getOtherSellersFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          height: 200,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: MyTheme.primary_color,
                                          )),
                                        );
                                      }
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        List<SellerGroupItem> sellersList =
                                            snapshot.data!;
                                        sellersList.removeWhere((item) =>
                                            item.sellerId ==
                                            currentUser.userId);
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
                                                      textAlign:
                                                          TextAlign.center,
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
                                                itemCount:
                                                    snapshot.data!.length,
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
                                                                      right:
                                                                          10),
                                                              actionsPadding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              buttonPadding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              content:
                                                                  Container(
                                                                height: 300,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        child: CachedNetworkImage(
                                                                            imageUrl:
                                                                                sellersList[index].imageURL,
                                                                            fit: BoxFit.cover),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          sellersList[index]
                                                                              .name,
                                                                          style: TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
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
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            sellersList[index].phoneNumber,
                                                                            style:
                                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                FaIcon(
                                                                              FontAwesomeIcons.whatsapp,
                                                                              color: sellersList[index].phoneNumber.isEmpty ? Colors.grey : Colors.green,
                                                                              size: 30,
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
                                                                    child: Text(
                                                                        AppLocalizations.of(context)!
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
                                                              aspectRatio:
                                                                  1 / 1,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    sellersList[
                                                                            index]
                                                                        .imageURL,
                                                                fit: BoxFit
                                                                    .cover,
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
                          return SizedBox();
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
                  child: Text(
                    AppLocalizations.of(context)!.friends,
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .5,
                        fontFamily: 'Poppins'),
                  ),
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
                imageUrl: image!,
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
