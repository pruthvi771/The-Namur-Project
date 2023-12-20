// translation done.

import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HiveMachineDetails extends StatefulWidget {
  final String machineName;
  final String landSynoValue;

  const HiveMachineDetails({
    Key? key,
    required this.machineName,
    required this.landSynoValue,
  }) : super(key: key);

  @override
  State<HiveMachineDetails> createState() => HiveMachineDetailsState();
}

class HiveMachineDetailsState extends State<HiveMachineDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.machineName,
          style: TextStyle(
              color: MyTheme.white,
              fontWeight: FontWeight.w500,
              letterSpacing: .5,
              fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
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
      body: RefreshIndicator(
        onRefresh: () async {},
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('hiveMachineName', isEqualTo: widget.machineName)
              .where('landSynoValue', isEqualTo: widget.landSynoValue)
              .where('subSubCategory', isEqualTo: 'On Rent')
              .where('isDeleted', isNotEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              var products = snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map;
                // if (!containsItem(
                //     subSubCategoryList, data['subSubCategory'])) {
                //   subSubCategoryList.add(FilterItem(
                //       name: data['subSubCategory'], isSelected: true));
                // }
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
                  village: data['villageName'],
                  gramPanchayat: data['gramPanchayat'],
                  taluk: data['taluk'],
                  district: data['district'],
                  createdAt: data['createdAt'].toDate(),
                );
              }).toList();

              return Container(
                child: products.length == 0
                    // short circuiting
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_product_found,
                          style: TextStyle(fontSize: 20, color: Colors.black45),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Column(
                        children: [
                          // filtering menu
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
              // Navigator.push(
              //   context,
              //   // MaterialPageRoute(
              //   builder: (context) => MachineDetails(
              //     sellProduct: products[index],
              //     onRent: products[index].subSubCategory == 'On Rent',
              //   ),
              // ),
              // );
            }
            // else {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ProductDetails(
            //       sellProduct: products[index],
            //     ),
            //   ),
            // );
            // }
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
                                  subSubCategory == 'On Rent'
                                      ? '/ 30 mins'
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
