import 'dart:ui';

import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/subSubCategory_filter_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/machine_rent_form.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/product_details_screen.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  @override
  void initState() {
    // BlocProvider.of<BuyBloc>(context).add(BuyProductsForSubCategoryRequested(
    //   subCategory: nameForSubCategoryEnum[widget.subCategoryEnum]!,
    // ));
    // subSubCategoryList = ;
    subSubCategoryList = List.from(SubSubCategoryList[widget.subCategoryEnum]!);
    selectedSubSubcategories = subSubCategoryList
        .map((subSubCategory) => SubSubCategoryFilterItem(
              subSubCategoryName: subSubCategory,
              isSelected: true,
            ))
        .toList();
    super.initState();
  }

  late List<String> subSubCategoryList;

  late List<SubSubCategoryFilterItem> selectedSubSubcategories;

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

  bool isALL = true;

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
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('subCategory',
                      isEqualTo: nameForSubCategoryEnum[widget.subCategoryEnum])
                  .where('isSecondHand', isEqualTo: widget.isSecondHand)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var products = snapshot.data!.docs.map((doc) {
                    var data = doc.data();
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
                                color: Colors.grey[100],
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      // width: 40,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectAllCategories();
                                            isALL = isALLSelected();
                                          });
                                        },
                                        child: Text(
                                          'All',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(1),
                                            backgroundColor: isALL
                                                ? MaterialStatePropertyAll(
                                                    Colors.green[100])
                                                : MaterialStatePropertyAll(
                                                    Colors.green[50])),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: subSubCategoryList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedSubSubcategories[index]
                                                        .isSelected =
                                                    !selectedSubSubcategories[
                                                            index]
                                                        .isSelected;
                                                isALL = isALLSelected();
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        selectedSubSubcategories[
                                                                    index]
                                                                .isSelected
                                                            ? Colors.green[100]
                                                            : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        width: 1,
                                                        color:
                                                            selectedSubSubcategories[
                                                                        index]
                                                                    .isSelected
                                                                ? Colors.green
                                                                : Colors.grey)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 8),
                                                  child: Text(
                                                    selectedSubSubcategories[
                                                            index]
                                                        .subSubCategoryName,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    ListView.builder(
                                        itemCount: products.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return containsSelected(
                                                  subSubCategoryName:
                                                      products[index]
                                                          .subSubCategory)
                                              ? InkWell(
                                                  onTap: () {
                                                    if (products[index]
                                                            .subSubCategory ==
                                                        'On Rent') {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                MachineRentForm(
                                                              imageURL:
                                                                  products[
                                                                          index]
                                                                      .imageURL,
                                                              machineName:
                                                                  products[
                                                                          index]
                                                                      .productName,
                                                              machinePrice:
                                                                  products[
                                                                          index]
                                                                      .productPrice,
                                                              machineDescription:
                                                                  products[
                                                                          index]
                                                                      .productDescription,
                                                            ),
                                                          ));
                                                    } else {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
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
                                                    imageURL: products[index]
                                                        .imageURL,
                                                    price: products[index]
                                                        .productPrice,
                                                    quantityUnit:
                                                        products[index]
                                                            .quantityUnit,
                                                    description: products[index]
                                                        .productDescription,
                                                    subSubCategory:
                                                        products[index]
                                                            .subSubCategory,
                                                  ),
                                                )
                                              : Container();
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
    required String description,
    required String subSubCategory,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: MyTheme.medium_grey)),
          height: 130,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      height: 110,
                      child: imageURL.isEmpty || imageURL.length == 0
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                imageURL[0],
                                fit: BoxFit.cover,
                              ),
                            )),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          // 'skgknkl kgsne ksngkla lkgnlkang lkenglkg',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          subSubCategory,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '₹$price per ${quantityUnit == "Units" ? 'unit' : quantityUnit}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MyTheme.grey_153,
                          ),
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
}
