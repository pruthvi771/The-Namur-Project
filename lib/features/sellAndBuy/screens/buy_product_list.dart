import 'package:active_ecommerce_flutter/data_model/check_response.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/friends_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/filter_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/machine_rent_form.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/parent_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/product_details_screen.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
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
  final List<FilterItem>? locationsList;
  final SortType? sortType;

  BuyProductList({
    Key? key,
    required this.subCategoryEnum,
    required this.isSecondHand,
    this.locationsList,
    this.subSubCategoryList,
    this.sortType,
  }) : super(key: key);

  @override
  _BuyProductListState createState() => _BuyProductListState();
}

class _BuyProductListState extends State<BuyProductList> {
  String? sortByDropdownValue;
  bool isALL = true;
  bool fitlerLocationTabOpen = true;

  List<String> selectedCategories = [];
  List<String> selectedLocations = [];
  late Stream<QuerySnapshot> productsStream;

  late List<FilterItem> subSubCategoryList;
  late List<FilterItem> locationsList;
  late SortType? sortType;
  final String collectionName = 'buyer';
  late final bool locationFilter;
  int text = 0;

  @override
  void initState() {
    subSubCategoryList =
        widget.subSubCategoryList != null ? widget.subSubCategoryList! : [];
    locationsList = widget.locationsList != null ? widget.locationsList! : [];
    sortType = widget.sortType != null ? widget.sortType! : null;
    // getCountFuture = getCount(count: null);

    try {
      print(subSubCategoryList[0].name);
      print(subSubCategoryList[0].isSelected);
      print(subSubCategoryList[1].name);
      print(subSubCategoryList[1].isSelected);
    } catch (e) {}

    if (sortType != null && subSubCategoryList.length == 0) {
      productsStream = allProductSortedStreamQuery(sortType: sortType!);
    } else if (subSubCategoryList.length != 0 && sortType == null) {
      productsStream = productFilteredStreamQuery(
        theSubSubCategoryList: subSubCategoryList,
      );
    } else if (subSubCategoryList.length != 0 && sortType != null) {
      productsStream = productFilteredAndSortedStreamQuery(
          sortType: sortType!, theSubSubCategoryList: subSubCategoryList);
    } else {
      productsStream = allProductStreamQuery();
    }

    if (locationsList != null && locationsList.length != 0) {
      locationFilter = true;
    } else {
      locationFilter = false;
    }
    super.initState();
  }

  Stream<QuerySnapshot> allProductStreamQuery() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('subCategory',
            isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
        .snapshots();
  }

  Stream<QuerySnapshot> allProductSortedStreamQuery(
      {required SortType sortType}) {
    String orderByField = 'price';

    return FirebaseFirestore.instance
        .collection('products')
        .where('subCategory',
            isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
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

    return FirebaseFirestore.instance
        .collection('products')
        .where('subCategory',
            isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
        .where('subSubCategory', whereIn: subSubCategoryList)
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

    return FirebaseFirestore.instance
        .collection('products')
        .where('subCategory',
            isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
        .where('subSubCategory',
            whereIn: subSubCategoryList.length != 0 ? subSubCategoryList : [''])
        .orderBy('price', descending: sortType == SortType.descending)
        .snapshots();
  }

  void goToFilterScreen({
    required BuildContext context,
    required SubCategoryEnum subCategoryEnum,
    required bool isSecondHand,
    required List<FilterItem> theSubSubCategoryList,
    required List<FilterItem> theLocationsList,
    required SortType? theSortType,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FilterScreen(
            subCategoryEnum: subCategoryEnum,
            isSecondHand: isSecondHand,
            subSubCategoryList: theSubSubCategoryList,
            locationsList: theLocationsList,
            sortType: theSortType,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.0);
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

  // late Future<int?> getCountFuture;

  // Future<int?> getCount({
  //   required int? count,
  // }) async {
  //   if (count == null) {
  //     return null;
  //   }
  //   return count;
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
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
          ),
          body: StreamBuilder(
              stream: productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  var products = snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map;
                    if (!containsItem(
                        subSubCategoryList, data['subSubCategory'])) {
                      subSubCategoryList.add(FilterItem(
                          name: data['subSubCategory'], isSelected: true));
                    }
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
                    );
                  }).toList();

                  return Container(
                    child: products.length == 0
                        // short circuiting
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .no_product_is_available,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              // filtering menu
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // filter by
                                    GestureDetector(
                                      onTap: () {
                                        goToFilterScreen(
                                            context: context,
                                            subCategoryEnum:
                                                widget.subCategoryEnum,
                                            isSecondHand: widget.isSecondHand,
                                            theSubSubCategoryList:
                                                subSubCategoryList,
                                            theLocationsList: locationsList,
                                            theSortType: sortType);
                                      },
                                      child: Container(
                                        child: Chip(
                                          backgroundColor: Colors.grey[200],
                                          labelPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                          label: Text('Show Filter'),
                                          deleteIcon: FaIcon(
                                            FontAwesomeIcons.sliders,
                                            size: 15,
                                          ),
                                          onDeleted: () {
                                            goToFilterScreen(
                                              context: context,
                                              subCategoryEnum:
                                                  widget.subCategoryEnum,
                                              isSecondHand: widget.isSecondHand,
                                              theSubSubCategoryList:
                                                  subSubCategoryList,
                                              theLocationsList: locationsList,
                                              theSortType: sortType,
                                            );
                                          },
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
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return StreamBuilder<
                                                  DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection(collectionName)
                                                  .doc(products[index].sellerId)
                                                  .snapshots(),
                                              builder:
                                                  (context, sellerSnapshot) {
                                                if (sellerSnapshot.hasData &&
                                                    sellerSnapshot
                                                        .data!.exists &&
                                                    sellerSnapshot.data !=
                                                        null) {
                                                  var sellerData =
                                                      sellerSnapshot.data!
                                                              .data()
                                                          as Map<String,
                                                              dynamic>?;

                                                  var villageName =
                                                      sellerData!['profileData']
                                                              ['address'][0]
                                                          ['village'];

                                                  if (!containsItem(
                                                    locationsList,
                                                    villageName,
                                                  )) {
                                                    locationsList.add(
                                                      FilterItem(
                                                          name: villageName,
                                                          isSelected: true),
                                                    );
                                                  }
                                                  if (locationFilter) {
                                                    if (containsItemAsSelected(
                                                      locationsList,
                                                      villageName,
                                                    )) {
                                                      // text = text + 1;
                                                      // getCountFuture =
                                                      //     getCount(count: text);
                                                      return ProductCard(
                                                          products,
                                                          index,
                                                          context,
                                                          sellerData);
                                                    }
                                                  } else {
                                                    // text = text + 1;
                                                    // getCountFuture =
                                                    //     getCount(count: text);
                                                    return ProductCard(
                                                        products,
                                                        index,
                                                        context,
                                                        sellerData);
                                                  }
                                                }
                                                return SizedBox.shrink();
                                              });
                                        }),
                                  ],
                                ),
                              ),
                              // FutureBuilder(
                              //     future: getCountFuture,
                              //     builder: (context, snapshot) {
                              //       if (snapshot.hasData &&
                              //           snapshot.data != null) {
                              //         return Container(
                              //           child: Text(snapshot.data.toString()),
                              //         );
                              //       }
                              //       return Container(
                              //         child: Text('empty'),
                              //       );
                              //     }),
                            ],
                          ),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Something went wrong. Please try again.');
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }

  Column ProductCard(List<SellProduct> products, int index,
      BuildContext context, Map<String, dynamic> sellerData) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (products[index].subSubCategory == 'On Rent') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MachineRentForm(
                      imageURL: products[index].imageURL,
                      machineName: products[index].productName,
                      machinePrice: products[index].productPrice,
                      machineDescription: products[index].productDescription,
                    ),
                  ));
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
            // description:
            //     products[index]
            //         .productDescription,
            subSubCategory: products[index].subSubCategory,
            village:
                sellerData!['profileData']['address'][0]['village'] ?? '---',
            district:
                sellerData['profileData']['address'][0]['district'] ?? '---',
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
          height: 160,
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
                                  ' per ${quantityUnit == "Units" ? 'unit' : quantityUnit}',
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
