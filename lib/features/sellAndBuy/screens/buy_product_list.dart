import 'package:active_ecommerce_flutter/features/profile/screens/edit_profile.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/filter_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/machine_details_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/product_details_screen.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:active_ecommerce_flutter/utils/functions.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum FilterType { subSubCategory, location }

class BuyProductList extends StatefulWidget {
  final SubCategoryEnum subCategoryEnum;
  final bool isSecondHand;
  final List<FilterItem>? subSubCategoryList;
  // final List<FilterItem>? locationsList;
  final LocationFilterMap? locationFilterMap;
  final SortType? sortType;
  final bool? isRent;
  final bool? isMachine;
  BuyProductList({
    Key? key,
    required this.subCategoryEnum,
    required this.isSecondHand,
    this.locationFilterMap,
    this.subSubCategoryList,
    this.sortType,
    this.isRent,
    this.isMachine,
  }) : super(key: key);

  @override
  _BuyProductListState createState() => _BuyProductListState();
}

class _BuyProductListState extends State<BuyProductList> {
  // late bool? isRent;

  String? sortByDropdownValue;
  bool isALL = true;
  bool fitlerLocationTabOpen = true;

  List<String> selectedCategories = [];
  late Stream<QuerySnapshot> productsStream;
  late List<FilterItem> subSubCategoryList;
  late List<String> bareSubSubCategoryList;
  late SortType? sortType;
  final String collectionName = 'buyer';
  int text = 0;
  late Address? userLocation;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late LocationFilterMap currentLocationFilterMap;

  final String villageNameField = 'villageName';
  final String gramPanchayatField = 'gramPanchayat';
  final String talukField = 'taluk';
  final String districtField = 'district';

  @override
  void initState() {
    userLocation = getUserLocationFromHive();
    if (userLocation == null) {
      super.initState();
      return;
    }

    List<FilterItem> temp = [];
    bareSubSubCategoryList = SubSubCategoryList[widget.subCategoryEnum] ??
        [nameForSubCategoryEnum[widget.subCategoryEnum]!];

    bareSubSubCategoryList.forEach((element) {
      temp.add(FilterItem(name: element, isSelected: true));
    });

    subSubCategoryList =
        widget.subSubCategoryList != null ? widget.subSubCategoryList! : temp;

    if (widget.isRent != null) {
      if (widget.isRent == true) {
        subSubCategoryList = [
          FilterItem(name: 'On Rent', isSelected: true),
          FilterItem(name: 'Sell', isSelected: false),
        ];
      } else {
        subSubCategoryList = [
          FilterItem(name: 'On Rent', isSelected: false),
          FilterItem(name: 'Sell', isSelected: true),
        ];
      }
    }

    if (widget.locationFilterMap != null) {
      currentLocationFilterMap = widget.locationFilterMap!;
    } else {
      currentLocationFilterMap = LocationFilterMap(
        district: true,
        taluk: false,
        gramPanchayat: false,
        village: false,
      );
    }

    sortType = widget.sortType != null ? widget.sortType! : null;

    if (sortType != null && subSubCategoryList.length == 0) {
      productsStream = productFilteredByLocationAndSortedStreamQuery(
        locationFilterMap: currentLocationFilterMap,
        sortType: sortType!,
      );
    } else if (subSubCategoryList.length != 0 && sortType == null) {
      productsStream = productFilteredByLocationAndSubSubCategoryStreamQuery(
        locationFilterMap: currentLocationFilterMap,
        theSubSubCategoryList: subSubCategoryList,
      );
    } else if (subSubCategoryList.length != 0 && sortType != null) {
      productsStream = productAllFiltersAndSortedStreamQuery(
        locationFilterMap: currentLocationFilterMap,
        sortType: sortType!,
        theSubSubCategoryList: subSubCategoryList,
      );
    } else {
      productsStream = productFilteredByLocationStreamQuery(
        locationFilterMap: currentLocationFilterMap,
      );
    }
    super.initState();
  }

  Stream<QuerySnapshot> allProductSortedStreamQuery({
    required SortType sortType,
  }) {
    String orderByField = 'price';

    return _firestore
        .collection('products')
        .where('subCategory',
            isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
        .where('isDeleted', isEqualTo: false)
        .where('quantity', isGreaterThan: 0)
        .orderBy(orderByField, descending: sortType == SortType.descending)
        .snapshots();
  }

  Stream<QuerySnapshot> productFilteredStreamQuery({
    List<FilterItem>? theSubSubCategoryList,
  }) {
    List<String> subSubCategoryList = [];
    for (var item in theSubSubCategoryList!) {
      if (item.isSelected) {
        subSubCategoryList.add(item.name);
      }
    }

    return _firestore
        .collection('products')
        .where('subCategory',
            isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
        .where('subSubCategory', whereIn: subSubCategoryList)
        .where('isDeleted', isEqualTo: false)
        .where('quantity', isGreaterThan: 0)
        .snapshots();
  }

  Stream<QuerySnapshot> productFilteredAndSortedStreamQuery({
    required SortType sortType,
    List<FilterItem>? theSubSubCategoryList,
  }) {
    List<String> subSubCategoryList = [];
    for (var item in theSubSubCategoryList!) {
      if (item.isSelected) {
        subSubCategoryList.add(item.name);
      }
    }

    return _firestore
        .collection('products')
        .where('subCategory',
            isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
        .where('subSubCategory',
            whereIn: subSubCategoryList.length != 0 ? subSubCategoryList : [''])
        .where('isDeleted', isEqualTo: false)
        .where('quantity', isGreaterThan: 0)
        .orderBy('price', descending: sortType == SortType.descending)
        .snapshots();
  }

  Stream<QuerySnapshot> productFilteredByLocationStreamQuery({
    required LocationFilterMap locationFilterMap,
  }) {
    var defaultQuery = _firestore
        .collection('products')
        .where('subCategory',
            isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
        .where('quantity', isGreaterThan: 0)
        .where('isDeleted', isEqualTo: false);

    if (locationFilterMap.district) {
      return defaultQuery
          .where(districtField, isEqualTo: userLocation!.district)
          .snapshots();
    } else if (locationFilterMap.taluk) {
      return defaultQuery
          .where(talukField, isEqualTo: userLocation!.taluk)
          .snapshots();
    } else if (locationFilterMap.gramPanchayat) {
      return defaultQuery
          .where(gramPanchayatField, isEqualTo: userLocation!.gramPanchayat)
          .snapshots();
    } else {
      return defaultQuery
          .where(villageNameField, isEqualTo: userLocation!.village)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> productFilteredByLocationAndSubSubCategoryStreamQuery({
    required LocationFilterMap locationFilterMap,
    List<FilterItem>? theSubSubCategoryList,
  }) {
    List<String> subSubCategoryList = [];
    for (var item in theSubSubCategoryList!) {
      if (item.isSelected) {
        subSubCategoryList.add(item.name);
      }
    }

    if (locationFilterMap.district) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where('subSubCategory',
              whereIn:
                  subSubCategoryList.length != 0 ? subSubCategoryList : [''])
          .where(districtField, isEqualTo: userLocation!.district)
          .where('quantity', isGreaterThan: 0)
          .where('isDeleted', isEqualTo: false)
          .snapshots();
    } else if (locationFilterMap.taluk) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where('quantity', isGreaterThan: 0)
          .where('subSubCategory',
              whereIn:
                  subSubCategoryList.length != 0 ? subSubCategoryList : [''])
          .where(talukField, isEqualTo: userLocation!.taluk)
          .where('isDeleted', isEqualTo: false)
          .snapshots();
    } else if (locationFilterMap.gramPanchayat) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where('quantity', isGreaterThan: 0)
          .where('subSubCategory',
              whereIn:
                  subSubCategoryList.length != 0 ? subSubCategoryList : [''])
          .where(gramPanchayatField, isEqualTo: userLocation!.gramPanchayat)
          .where('isDeleted', isEqualTo: false)
          .snapshots();
    } else {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where('subSubCategory',
              whereIn:
                  subSubCategoryList.length != 0 ? subSubCategoryList : [''])
          .where(villageNameField, isEqualTo: userLocation!.village)
          .where('quantity', isGreaterThan: 0)
          .where('isDeleted', isEqualTo: false)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> productFilteredByLocationAndSortedStreamQuery({
    required LocationFilterMap locationFilterMap,
    required SortType sortType,
  }) {
    String orderByField = 'price';
    if (locationFilterMap.district) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where(districtField, isEqualTo: userLocation!.district)
          .where('isDeleted', isEqualTo: false)
          .where('quantity', isGreaterThan: 0)
          .orderBy(orderByField, descending: sortType == SortType.descending)
          .snapshots();
    } else if (locationFilterMap.taluk) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where(talukField, isEqualTo: userLocation!.taluk)
          .where('isDeleted', isEqualTo: false)
          .where('quantity', isGreaterThan: 0)
          .orderBy(orderByField, descending: sortType == SortType.descending)
          .snapshots();
    } else if (locationFilterMap.gramPanchayat) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where(gramPanchayatField, isEqualTo: userLocation!.gramPanchayat)
          .where('isDeleted', isEqualTo: false)
          .where('quantity', isGreaterThan: 0)
          .orderBy(orderByField, descending: sortType == SortType.descending)
          .snapshots();
    } else {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where(villageNameField, isEqualTo: userLocation!.village)
          .where('isDeleted', isEqualTo: false)
          .where('quantity', isGreaterThan: 0)
          .orderBy(orderByField, descending: sortType == SortType.descending)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> productAllFiltersAndSortedStreamQuery({
    required LocationFilterMap locationFilterMap,
    List<FilterItem>? theSubSubCategoryList,
    required SortType sortType,
  }) {
    String orderByField = 'price';

    List<String> subSubCategoryList = [];
    for (var item in theSubSubCategoryList!) {
      if (item.isSelected) {
        subSubCategoryList.add(item.name);
      }
    }

    if (locationFilterMap.district) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where('subSubCategory',
              whereIn:
                  subSubCategoryList.length != 0 ? subSubCategoryList : [''])
          .where(districtField, isEqualTo: userLocation!.district)
          .where('isDeleted', isEqualTo: false)
          .where('quantity', isGreaterThan: 0)
          .orderBy('quantity', descending: sortType == SortType.descending)
          .orderBy(orderByField, descending: sortType == SortType.descending)
          .snapshots();
    } else if (locationFilterMap.taluk) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where('subSubCategory',
              whereIn:
                  subSubCategoryList.length != 0 ? subSubCategoryList : [''])
          .where(talukField, isEqualTo: userLocation!.taluk)
          .where('isDeleted', isEqualTo: false)
          .where('quantity', isGreaterThan: 0)
          .orderBy('quantity', descending: sortType == SortType.descending)
          .orderBy(orderByField, descending: sortType == SortType.descending)
          .snapshots();
    } else if (locationFilterMap.gramPanchayat) {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where('subSubCategory',
              whereIn:
                  subSubCategoryList.length != 0 ? subSubCategoryList : [''])
          .where(gramPanchayatField, isEqualTo: userLocation!.gramPanchayat)
          .where('isDeleted', isEqualTo: false)
          .where('quantity', isGreaterThan: 0)
          .orderBy('quantity', descending: sortType == SortType.descending)
          .orderBy(orderByField, descending: sortType == SortType.descending)
          .snapshots();
    } else {
      return _firestore
          .collection('products')
          .where('subCategory',
              isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
          .where('isSecondHand', isEqualTo: widget.isSecondHand)
          .where('subSubCategory',
              whereIn:
                  subSubCategoryList.length != 0 ? subSubCategoryList : [''])
          .where(villageNameField, isEqualTo: userLocation!.village)
          .where('isDeleted', isEqualTo: false)
          .where('quantity', isGreaterThan: 0)
          .orderBy('quantity', descending: sortType == SortType.descending)
          .orderBy(orderByField, descending: sortType == SortType.descending)
          .snapshots();
    }
  }

  void goToFilterScreen({
    required BuildContext context,
    required SubCategoryEnum subCategoryEnum,
    required bool isSecondHand,
    required List<FilterItem> theSubSubCategoryList,
    required SortType? theSortType,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          print((widget.isRent));
          return FilterScreen(
            isMachine: widget.isMachine,
            locationFilterMap: currentLocationFilterMap,
            subCategoryEnum: subCategoryEnum,
            isSecondHand: isSecondHand,
            subSubCategoryList: theSubSubCategoryList,
            sortType: theSortType,
            isRent: widget.isRent,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  containsItem(List<FilterItem> list, String name) {
    for (var item in list) {
      if (item.name == name) {
        return true;
      }
    }
    return false;
  }

  containsItemAsSelected(List<FilterItem> list, String name) {
    for (var item in list) {
      if (item.name == name && item.isSelected) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff107B28), Color(0xff4C7B10)]),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.all_products_ucf,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins'),
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
        body: userLocation == null
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .please_add_address_to_see_products,
                      style: TextStyle(fontSize: 20, color: Colors.black45),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.primary_color,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.add_address)),
                  ],
                ),
              )
            : StreamBuilder(
                stream: productsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    var bareProducts = snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map;
                      return SellProduct(
                        id: doc.id,
                        productName: data['name'],
                        productDescription: data['description'],
                        productPrice: data['price'],
                        productQuantity: data['quantity'],
                        quantityUnit: data['quantityUnit'],
                        category: data['category'],
                        subCategory: data['subCategory'],
                        subSubCategory: data['subSubCategory'],
                        imageURL: data['imageURL'],
                        sellerId: data['sellerId'],
                        isSecondHand: data['isSecondHand'],
                        village: data['villageName'] ?? "",
                        gramPanchayat: data['gramPanchayat'] ?? "",
                        taluk: data['taluk'] ?? "",
                        district: data['district'] ?? "",
                        createdAt: data['createdAt'].toDate(),
                      );
                    }).toList();
                    // order this list based on createdAt
                    bareProducts
                        .sort((a, b) => b.createdAt.compareTo(a.createdAt));
                    List<SellProduct> products = bareProducts
                        .where((product) =>
                            product.district.isNotEmpty &&
                            product.taluk.isNotEmpty &&
                            product.gramPanchayat.isNotEmpty &&
                            product.village.isNotEmpty)
                        .toList();
                    // Add animation before loading
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              child: products.length == 0
                                  // short circuiting
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // filter by
                                              GestureDetector(
                                                onTap: () {
                                                  goToFilterScreen(
                                                    context: context,
                                                    subCategoryEnum:
                                                        widget.subCategoryEnum,
                                                    isSecondHand:
                                                        widget.isSecondHand,
                                                    theSubSubCategoryList:
                                                        subSubCategoryList,
                                                    theSortType: sortType,
                                                  );
                                                },
                                                child: Container(
                                                  child: Chip(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    labelPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 0),
                                                    label: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .show_filters),
                                                    deleteIcon: FaIcon(
                                                      FontAwesomeIcons.sliders,
                                                      size: 15,
                                                    ),
                                                    onDeleted: () {
                                                      goToFilterScreen(
                                                          context: context,
                                                          subCategoryEnum: widget
                                                              .subCategoryEnum,
                                                          isSecondHand: widget
                                                              .isSecondHand,
                                                          theSubSubCategoryList:
                                                              subSubCategoryList,
                                                          theSortType:
                                                              sortType);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .no_product_found,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black45),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        // filtering menu
                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // filter by
                                              GestureDetector(
                                                onTap: () {
                                                  goToFilterScreen(
                                                    context: context,
                                                    subCategoryEnum:
                                                        widget.subCategoryEnum,
                                                    isSecondHand:
                                                        widget.isSecondHand,
                                                    theSubSubCategoryList:
                                                        subSubCategoryList,
                                                    theSortType: sortType,
                                                  );
                                                },
                                                child: Container(
                                                  child: Chip(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    labelPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 0),
                                                    label: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .show_filters),
                                                    deleteIcon: FaIcon(
                                                      FontAwesomeIcons.sliders,
                                                      size: 15,
                                                    ),
                                                    onDeleted: () {},
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView(
                                            physics: BouncingScrollPhysics(),
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              ListView.builder(
                                                itemCount: products.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) {
                                                  return ProductCard(
                                                    products,
                                                    index,
                                                    context,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                    );
                  }
                  if (snapshot.hasError) {
                    // return Text('Something went wrong. Please try again.');
                    return SizedBox.shrink();
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
      ),
    );
  }

  Column ProductCard(
    List<SellProduct> products,
    int index,
    BuildContext context,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (products[index].subSubCategory == 'On Rent' ||
                products[index].subSubCategory == 'Sell') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MachineDetails(
                    sellProduct: products[index],
                    onRent: products[index].subSubCategory == 'On Rent',
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(
                    sellProduct: products[index],
                  ),
                ),
              );
            }
          },
          child: BuyProductTile(
            context: context,
            name: products[index].productName,
            imageURL: products[index].imageURL,
            price: products[index].productPrice,
            quantityUnit: products[index].quantityUnit,
            subSubCategory: products[index].subSubCategory,
            village: products[index].village,
            district: products[index].district,
            createdAt: products[index].createdAt,
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Padding BuyProductTile({
    required BuildContext context,
    required String name,
    required List<dynamic> imageURL,
    required double price,
    required String quantityUnit,
    // required String description,
    required String subSubCategory,
    required String village,
    required String district,
    required DateTime createdAt,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        // bottom: 8,
      ),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(left: 5),
                      height: 140,
                      child: imageURL.isEmpty || imageURL.length == 0
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: imageURL[0],
                                fit: BoxFit.cover,
                              ),
                            )),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          // 'skgknkl kgsne ksngkla lkgnlkang lkenglkg',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          subSubCategory.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹',
                                    style: TextStyle(
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox.shrink()
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${price.toInt()}',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  subSubCategory == 'On Rent'
                                      ? '/ Hr'
                                      : ' per ${quantityUnit == "Units" ? 'unit' : quantityUnit}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    // fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.locationPin,
                              size: 14,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                '$village, $district',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.clock,
                              size: 14,
                              // color: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                formatDateWithYear(
                                    createdAt.toString().substring(0, 10)),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: -0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Column DropdownButtonWidget(
      // String title,
      List<DropdownMenuItem<String>>? itemList,
      String dropdownValue,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            filled: true,
            fillColor: MyTheme.light_grey,
            contentPadding: EdgeInsets.only(left: 20, right: 10),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            underline: SizedBox(),
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            onChanged: (String? value) {
              onChanged(value!);
            },
            items: itemList,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
