// translation done.

import 'package:active_ecommerce_flutter/features/sellAndBuy/models/sell_product.dart';
import 'package:active_ecommerce_flutter/utils/functions.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MachineBookings extends StatefulWidget {
  final String productId;
  final String title;

  MachineBookings({
    Key? key,
    required this.productId,
    required this.title,
  }) : super(key: key);

  @override
  _MachineBookingsState createState() => _MachineBookingsState();
}

class _MachineBookingsState extends State<MachineBookings> {
  Map<String, Map<String, int>> productMap = {};

  @override
  void initState() {
    currentUser = _firebaseAuth.currentUser!;
    productDetailsFuture = getProductDetails();
    super.initState();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final currentUser;

  late Future<SellProduct> productDetailsFuture;

  Future<SellProduct> getProductDetails() async {
    final productDoc =
        await _firestore.collection('products').doc(widget.productId).get();
    var data = productDoc.data()!;

    SellProduct sellProduct = SellProduct(
      id: widget.productId,
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

    return sellProduct;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          drawer: const MainDrawer(),
          backgroundColor: Colors.white,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff107B28), Color(0xff4C7B10)]),
              ),
            ),
            title: Text(widget.title,
                style: TextStyle(
                    color: MyTheme.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins')),
            centerTitle: true,
          ),
          body: FutureBuilder(
              future: productDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  SellProduct productDocument = snapshot.data as SellProduct;
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          height: 330,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(7),
                            // color: Colors.grey[50],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.product_details,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                      color: MyTheme.primary_color),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 200,
                                child: CachedNetworkImage(
                                  imageUrl: productDocument.imageURL[0],
                                  progressIndicatorBuilder:
                                      (context, child, loadingProgress) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: MyTheme.accent_color,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.name_ucf,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    productDocument.productName,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.price_ucf +
                                        '/30 mins',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '₹ ${productDocument.productPrice}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: MyTheme.green_lighter,
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.bookings,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                          stream: _firestore
                              .collection('orders')
                              .where('productID', isEqualTo: widget.productId)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            if (snapshot.hasData && snapshot.data != null) {
                              print(snapshot.data!.docs.length);
                              return snapshot.data!.docs.length == 0
                                  ? Container(
                                      height: 100,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .no_orders_yet,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: List.generate(
                                          snapshot.data!.docs.length, (index) {
                                        var orderData =
                                            snapshot.data!.docs[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FutureBuilder(
                                            future: _firestore
                                                .collection('buyer')
                                                .doc(orderData['buyer'])
                                                .get(),
                                            builder: (context, buyerSnapshot) {
                                              if (buyerSnapshot.hasData &&
                                                  buyerSnapshot.data != null) {
                                                var sellerData =
                                                    buyerSnapshot.data!.data();
                                                print(sellerData);
                                                return BookingOrderCard(
                                                  locationName:
                                                      orderData['locationName'],
                                                  buyerName:
                                                      sellerData?['name'] ?? "",
                                                  bookedDate:
                                                      orderData['bookedDate'],
                                                  bookedSlot:
                                                      orderData['bookedSlot'],
                                                  buyerImageURL:
                                                      sellerData?['photoURL'] ??
                                                          imageForNameCloud[
                                                              'placeholder']!,
                                                  buyerPhone: sellerData?[
                                                          'phone number'] ??
                                                      "",
                                                  buyerEmail:
                                                      sellerData?['email'] ??
                                                          "",
                                                  totalPrice:
                                                      orderData['totalAmount']
                                                          .toDouble(),
                                                  unitPrice: orderData['items']
                                                          [0]['price']
                                                      .toDouble(),
                                                );
                                              }
                                              return SizedBox.shrink();
                                            },
                                          ),
                                        );
                                      }),
                                    );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .could_not_fetch_order_details,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ));
  }

  Material BookingOrderCard({
    required String buyerImageURL,
    required String buyerName,
    required String? buyerPhone,
    required String? buyerEmail,
    required double totalPrice,
    required double unitPrice,
    required String bookedDate,
    required String bookedSlot,
    required String locationName,
  }) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
        height: 220,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Expanded(
              //   flex: 3,
              //   child: Container(
              //       padding: EdgeInsets.only(left: 5),
              //       height: 140,
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(5),
              //         child: CachedNetworkImage(
              //           imageUrl: productImageURL,
              //           fit: BoxFit.cover,
              //         ),
              //       )),
              // ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$bookedDate, $bookedSlot',
                        // 'skgknkl kgsne ksngkla lkgnlkang lkenglkg',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹' + totalPrice.toString(),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ' (₹$unitPrice x ${totalPrice / unitPrice} Hrs)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(),
                      Container(
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                child: (buyerImageURL == '')
                                    ? Image.asset(
                                        "assets/default_profile2.png",
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: buyerImageURL,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Container(
                                  height: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  // color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          buyerName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          buyerPhone ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          buyerEmail ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            buyerPhone != null
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        openWhatsAppChat(buyerPhone);
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.whatsapp,
                                        size: 35,
                                        color: Color(0xFF25d366),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: FaIcon(
                                        FontAwesomeIcons.whatsapp,
                                        size: 35,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(),
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {},
                                child: FaIcon(
                                  FontAwesomeIcons.locationPin,
                                  size: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                locationName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
