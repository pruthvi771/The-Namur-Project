import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/machine_rent_form.dart';
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
  late List<String> subSubCategoryList;
  late List<SubSubCategoryFilterItem> selectedSubSubcategories;
  bool isALL = true;
  bool fitlerLocationTabOpen = true;

  List<String> selectedCategories = [];
  List<String> selectedLocations = [];
  late Stream<QuerySnapshot> productsStream;

  String randomText = 'hello';

  late Future<Stream> _futureForUpdatingStream;

  Future<Stream> futureForUpdatingStream(
      {required Stream productsStream}) async {
    return productsStream;
  }

  @override
  void initState() {
    // BlocProvider.of<BuyBloc>(context).add(BuyProductsForSubCategoryRequested(
    //   subCategory: nameForSubCategoryEnum[widget.subCategoryEnum]!,
    // ));
    // subSubCategoryList = ;
    productsStream = allProductStreamQuery();
    _futureForUpdatingStream =
        futureForUpdatingStream(productsStream: productsStream);
    subSubCategoryList = List.from(SubSubCategoryList[widget.subCategoryEnum]!);
    selectedSubSubcategories = subSubCategoryList
        .map((subSubCategory) => SubSubCategoryFilterItem(
              subSubCategoryName: subSubCategory,
              isSelected: true,
            ))
        .toList();
    super.initState();
  }

  void selectAllCategories() {
    setState(() {
      selectedSubSubcategories = selectedSubSubcategories.map((subSubCategory) {
        return SubSubCategoryFilterItem(
            subSubCategoryName: subSubCategory.subSubCategoryName,
            isSelected: true);
      }).toList();
    });
  }

  bool isALLSelected() {
    if (selectedSubSubcategories
        .every((subSubCategory) => subSubCategory.isSelected == true)) {
      return true;
    } else {
      return false;
    }
  }

  bool containsSelected({required String subSubCategoryName}) {
    return selectedSubSubcategories.any((subSubCategory) =>
        subSubCategory.subSubCategoryName == subSubCategoryName &&
        subSubCategory.isSelected == true);
  }

  // void _showModalBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 400,
  //         child: Column(
  //           children: [
  //             Expanded(
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                     flex: 1,
  //                     child: Container(
  //                       color: Colors.grey[200],
  //                       child: ListView(
  //                         children: [
  //                           GestureDetector(
  //                             onTap: () {
  //                               setState(() {
  //                                 fitlerLocationTabOpen = false;
  //                               });
  //                             },
  //                             child: Container(
  //                               height: 50,
  //                               color: Colors.white,
  //                               child: Center(
  //                                 child: Text(
  //                                   'Location',
  //                                   style: TextStyle(
  //                                       fontSize: 15,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Container(
  //                             height: 50,
  //                             color: Colors.grey[100],
  //                             child: Center(
  //                               child: Text(
  //                                 'Category',
  //                                 style: TextStyle(
  //                                     fontSize: 15,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     flex: 2,
  //                     child: fitlerLocationTabOpen
  //                         ? Container(
  //                             padding: EdgeInsets.only(left: 10),
  //                             child: ListView(
  //                               children: [
  //                                 SizedBox(
  //                                   height: 25,
  //                                 ),
  //                                 FilterListItem(),
  //                                 FilterListItem(),
  //                                 FilterListItem(),
  //                                 FilterListItem(),
  //                                 FilterListItem(),
  //                                 FilterListItem(),
  //                               ],
  //                             ),
  //                           )
  //                         : Container(
  //                             padding: EdgeInsets.only(left: 10),
  //                             child: ListView(
  //                               children: [
  //                                 SizedBox(
  //                                   height: 25,
  //                                 ),
  //                                 FilterListItem(title: 'mello'),
  //                                 FilterListItem(title: 'mello'),
  //                                 FilterListItem(title: 'mello'),
  //                                 FilterListItem(title: 'mello'),
  //                                 FilterListItem(title: 'mello'),
  //                                 FilterListItem(title: 'mello'),
  //                               ],
  //                             ),
  //                           ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 15),
  //               height: 60,
  //               color: Colors.white,
  //               child: Row(
  //                 children: [
  //                   Expanded(child: SizedBox()),
  //                   Container(
  //                     width: 100,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         setState(() {
  //                           randomText = 'mello';
  //                         });
  //                       },
  //                       child: Text('Apply'),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: MyTheme.accent_color,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(6),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 400,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.grey[200],
                            child: _buildLeftPanel(setState),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildRightPanel(setState),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(child: SizedBox()),
                        Container(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              print('starting');
                              productsStream = allProductStreamQueryGoat();
                              _futureForUpdatingStream =
                                  futureForUpdatingStream(
                                      productsStream: productsStream);
                              print('ending');
                              setState(() {});
                            },
                            child: Text('Apply'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyTheme.accent_color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLeftPanel(StateSetter setState) {
    return ListView(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (!fitlerLocationTabOpen) {
                fitlerLocationTabOpen = true;
              }
            });
          },
          child: Container(
            height: 50,
            color: fitlerLocationTabOpen ? Colors.white : Colors.grey[300],
            child: Center(
              child: Text(
                'Location',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (fitlerLocationTabOpen) {
                fitlerLocationTabOpen = false;
              }
            });
          },
          child: Container(
            height: 50,
            color: fitlerLocationTabOpen ? Colors.grey[300] : Colors.white,
            child: Center(
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel(StateSetter setState) {
    return fitlerLocationTabOpen
        ? Container(
            padding: EdgeInsets.only(left: 10),
            child: ListView(
              children: [
                SizedBox(
                  height: 25,
                ),
                FilterListItem(),
                FilterListItem(),
                FilterListItem(),
                FilterListItem(),
                FilterListItem(),
                FilterListItem(),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.only(left: 10),
            child: ListView(
              children: [
                SizedBox(
                  height: 25,
                ),
                FilterListItem(title: 'mello'),
                FilterListItem(title: 'mello'),
                FilterListItem(title: 'mello'),
                FilterListItem(title: 'mello'),
                FilterListItem(title: 'mello'),
                FilterListItem(title: 'mello'),
              ],
            ),
          );
  }

  Container FilterListItem({String title = 'Hell0'}) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              print('tapped');
            },
            child: Icon(Icons.check_box),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
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
                        // : Column(
                        //     children: [
                        //       Container(
                        //         color: Colors.grey[100],
                        //         height: 50,
                        //         child: Row(
                        //           children: [
                        //             Container(
                        //               // width: 40,
                        //               padding: EdgeInsets.symmetric(
                        //                   horizontal: 10, vertical: 7.5),
                        //               child: ElevatedButton(
                        //                 onPressed: () {
                        //                   setState(() {
                        //                     selectAllCategories();
                        //                     isALL = isALLSelected();
                        //                   });
                        //                 },
                        //                 child: Text(
                        //                   'All',
                        //                   style: TextStyle(color: Colors.black),
                        //                 ),
                        //                 style: ButtonStyle(
                        //                     elevation:
                        //                         MaterialStateProperty.all(0),
                        //                     backgroundColor: isALL
                        //                         ? MaterialStatePropertyAll(
                        //                             Colors.green[300])
                        //                         : MaterialStatePropertyAll(
                        //                             Colors.green[100])),
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child: ListView.builder(
                        //                 physics: BouncingScrollPhysics(),
                        //                 itemCount: subSubCategoryList.length,
                        //                 scrollDirection: Axis.horizontal,
                        //                 itemBuilder: (context, index) {
                        //                   return InkWell(
                        //                     onTap: () {
                        //                       setState(() {
                        //                         selectedSubSubcategories[index]
                        //                                 .isSelected =
                        //                             !selectedSubSubcategories[
                        //                                     index]
                        //                                 .isSelected;
                        //                         isALL = isALLSelected();
                        //                       });
                        //                     },
                        //                     child: Padding(
                        //                       padding:
                        //                           const EdgeInsets.all(8.0),
                        //                       child: Container(
                        //                         decoration: BoxDecoration(
                        //                             color:
                        //                                 selectedSubSubcategories[
                        //                                             index]
                        //                                         .isSelected
                        //                                     ? Colors.green[100]
                        //                                     : Colors.white,
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     5),
                        //                             border: Border.all(
                        //                                 width: 1,
                        //                                 color:
                        //                                     selectedSubSubcategories[
                        //                                                 index]
                        //                                             .isSelected
                        //                                         ? Colors.green
                        //                                         : Colors.grey)),
                        //                         child: Padding(
                        //                           padding: const EdgeInsets
                        //                               .symmetric(
                        //                               horizontal: 10,
                        //                               vertical: 8),
                        //                           child: Text(
                        //                             selectedSubSubcategories[
                        //                                     index]
                        //                                 .subSubCategoryName,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        // selectedSubSubcategories
                        //         .every((item) => !item.isSelected)
                        //     ? Container(
                        //         height: 400,
                        //         child: Center(
                        //           child: Text(
                        //             'Please select at least one sub category.',
                        //             style: TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        : Column(
                            children: [
                              Text(randomText),
                              Container(
                                // color: Colors.red,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 33,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          // border: Border.all(
                                          //   color: Colors.grey,
                                          // ),
                                          color: Colors.grey[200]),
                                      child: DropdownButton<String>(
                                        // isExpanded: true,
                                        hint: Text(
                                          'Sort By',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                        value: sortByDropdownValue,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        underline:
                                            SizedBox(), // Remove the underline
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors
                                              .black, // You can customize the text color here
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            sortByDropdownValue = newValue!;
                                          });
                                        },
                                        items: [
                                          'Price (Low to high)',
                                          'Price (High to Low)'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showModalBottomSheet(context);
                                      },
                                      child: Container(
                                        child: Chip(
                                          backgroundColor: Colors.grey[200],
                                          labelPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                          label: Text('Filter'),
                                          deleteIcon: FaIcon(
                                            FontAwesomeIcons.sliders,
                                            size: 15,
                                          ),
                                          onDeleted: () {
                                            _showModalBottomSheet(context);
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
                                                                ));
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
