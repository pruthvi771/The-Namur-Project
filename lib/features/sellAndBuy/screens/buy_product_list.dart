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

class BuyProductList extends StatefulWidget {
  final SubCategoryEnum subCategoryEnum;
  final bool isSecondHand;
  BuyProductList({
    Key? key,
    required this.subCategoryEnum,
    required this.isSecondHand,
  }) : super(key: key);

  @override
  _BuyProductListState createState() => _BuyProductListState();
}

class _BuyProductListState extends State<BuyProductList> {
  String? sortByDropdownValue;
  // late List<String> subSubCategoryList;
  // late List<SubSubCategoryFilterItem> selectedSubSubcategories;
  bool isALL = true;
  bool fitlerLocationTabOpen = true;

  List<String> selectedCategories = [];
  List<String> selectedLocations = [];
  late Stream<QuerySnapshot> productsStream;

  late Future<Stream> _futureForUpdatingStream;

  List<FilterItem> subSubCategoryList = [];
  List<FilterItem> locationsList = [];

  Future<Stream> futureForUpdatingStream(
      {required Stream productsStream}) async {
    return productsStream;
  }

  @override
  void initState() {
    productsStream = allProductStreamQuery();
    _futureForUpdatingStream =
        futureForUpdatingStream(productsStream: productsStream);
    // subSubCategoryList = List.from(SubSubCategoryList[widget.subCategoryEnum]!);
    // selectedSubSubcategories = subSubCategoryList
    //     .map((subSubCategory) => SubSubCategoryFilterItem(
    //           subSubCategoryName: subSubCategory,
    //           isSelected: true,
    //         ))
    //     .toList();
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

  Stream<QuerySnapshot> allProductStreamQueryGoat() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('subCategory', isEqualTo: 'Goats')
        .where('isSecondHand', isEqualTo: widget.isSecondHand)
        .snapshots();
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
          ),
          // body: bodycontent()),
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
                    subSubCategoryList.add(FilterItem(
                        name: data['subSubCategory'], isSelected: true));
                    return SellProduct(
                      id: doc.id,
                      productName: data['name'],
                      productDescription: data['description'],
                      productPrice: data['price'],
                      productQuantity: data['quantity'],
                      quantityUnit: data['quantityUnit'],
                      // priceType: data['priceType'],
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
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // // sort by
                                    // Container(
                                    //   height: 33,
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 12.0),
                                    //   decoration: BoxDecoration(
                                    //       borderRadius:
                                    //           BorderRadius.circular(500),
                                    //       color: Colors.grey[200]),
                                    //   child: DropdownButton<String>(
                                    //     hint: Text(
                                    //       'Sort By',
                                    //       style: TextStyle(
                                    //         color: Colors.black,
                                    //         fontSize: 13,
                                    //       ),
                                    //     ),
                                    //     value: sortByDropdownValue,
                                    //     icon: Icon(Icons.arrow_drop_down),
                                    //     iconSize: 24,
                                    //     elevation: 16,
                                    //     underline: SizedBox(),
                                    //     style: TextStyle(
                                    //       fontSize: 14,
                                    //       color: Colors.black,
                                    //     ),
                                    //     onChanged: (String? newValue) {
                                    //       setState(() {
                                    //         sortByDropdownValue = newValue!;
                                    //       });
                                    //     },
                                    //     items: [
                                    //       'Price (Low to high)',
                                    //       'Price (High to Low)'
                                    //     ].map<DropdownMenuItem<String>>(
                                    //         (String value) {
                                    //       return DropdownMenuItem<String>(
                                    //         value: value,
                                    //         child: Text(value),
                                    //       );
                                    //     }).toList(),
                                    //   ),
                                    // ),

                                    // ElevatedButton(
                                    //     onPressed: () {
                                    //       setState(() {
                                    //         randomText = 'hello mello';
                                    //       });
                                    //     },
                                    //     child: Text('hello mello')),

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return FilterScreen();
                                            },
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(0.0, 1.0);
                                              const end = Offset.zero;
                                              const curve = Curves.easeInOut;
                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));
                                              var offsetAnimation =
                                                  animation.drive(tween);

                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
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
                                            // _showModalBottomSheet(
                                            //     context: context,
                                            //     subSubCategoryList:
                                            //         subSubCategoryList,
                                            //     locationList: locationsList);
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
                                                  .collection('buyer')
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
                                                  locationsList.add(FilterItem(
                                                      name: sellerData![
                                                                  'profileData']
                                                              ['address'][0]
                                                          ['village'],
                                                      isSelected: true));
                                                  return Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (products[index]
                                                                  .subSubCategory ==
                                                              'On Rent') {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          MachineRentForm(
                                                                    imageURL: products[
                                                                            index]
                                                                        .imageURL,
                                                                    machineName:
                                                                        products[index]
                                                                            .productName,
                                                                    machinePrice:
                                                                        products[index]
                                                                            .productPrice,
                                                                    machineDescription:
                                                                        products[index]
                                                                            .productDescription,
                                                                  ),
                                                                ));
                                                          } else {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProductDetails(
                                                                  sellProduct:
                                                                      products[
                                                                          index],
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: BuyProductTile(
                                                          context: context,
                                                          name: products[index]
                                                              .productName,
                                                          imageURL:
                                                              products[index]
                                                                  .imageURL,
                                                          price: products[index]
                                                              .productPrice,
                                                          quantityUnit:
                                                              products[index]
                                                                  .quantityUnit,
                                                          // description:
                                                          //     products[index]
                                                          //         .productDescription,
                                                          subSubCategory:
                                                              products[index]
                                                                  .subSubCategory,
                                                          village: sellerData![
                                                                          'profileData']
                                                                      [
                                                                      'address']
                                                                  [
                                                                  0]['village'] ??
                                                              '---',
                                                          district: sellerData[
                                                                          'profileData']
                                                                      [
                                                                      'address'][0]
                                                                  [
                                                                  'district'] ??
                                                              '---',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                    ],
                                                  );
                                                }
                                                return SizedBox.shrink();
                                              });
                                        }),
                                  ],
                                ),
                              ),
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
