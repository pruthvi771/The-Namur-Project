// translation done.

import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:active_ecommerce_flutter/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  final String orderID;

  CheckoutScreen({
    Key? key,
    required this.orderID,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, Map<String, int>> productMap = {};

  @override
  void initState() {
    currentUser = _firebaseAuth.currentUser!;
    orderDocDataFuture = _getOrderDocData();
    super.initState();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final currentUser;

  late Future<OrderDocument> orderDocDataFuture;

  Future<OrderDocument> _getOrderDocData() async {
    final cartDoc =
        await _firestore.collection('orders').doc(widget.orderID).get();

    List<OrderItem> orderItems = [];

    for (var item in cartDoc.data()!['items']) {
      orderItems.add(OrderItem(
        productID: item['productID'],
        price: item['price'],
        quantity: item['quantity'],
        sellerID: item['sellerID'],
      ));
    }

    OrderDocument orderDocument = OrderDocument(
      buyerID: cartDoc.data()!['buyer'],
      timestamp: cartDoc.data()!['orderDate'],
      totalAmount: cartDoc.data()!['totalAmount'],
      status: cartDoc.data()!['status'],
      sellers: cartDoc.data()!['sellers'],
      orderItems: orderItems,
    );

    return orderDocument;
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
            title: Text(AppLocalizations.of(context)!.order_details_ucf,
                style: TextStyle(
                    color: MyTheme.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins')),
            centerTitle: true,
          ),
          body: FutureBuilder(
              future: orderDocDataFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  OrderDocument orderDocument = snapshot.data as OrderDocument;
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Text(orderDocument.buyerID),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          height: 200,
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
                                  AppLocalizations.of(context)!
                                      .order_details_ucf,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                      color: MyTheme.primary_color),
                                ),
                              ),
                              SizedBox(
                                  // height: 2,
                                  ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .order_code_ucf,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    widget.orderID,
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
                                    AppLocalizations.of(context)!
                                        .order_date_ucf,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    orderDocument.timestamp.toDate().toString(),
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
                                    AppLocalizations.of(context)!.your_total,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '₹ ${orderDocument.totalAmount.toString()}',
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
                                    AppLocalizations.of(context)!.order_status,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    orderDocument.status,
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
                            AppLocalizations.of(context)!.ordered_product_ucf,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: List.generate(
                            orderDocument.orderItems.length,
                            (index) {
                              return FutureBuilder(
                                  future: _firestore
                                      .collection('products')
                                      .doc(orderDocument
                                          .orderItems[index].productID)
                                      .get(),
                                  builder: (context, productSnapshot) {
                                    if (productSnapshot.hasData &&
                                        productSnapshot.data != null) {
                                      var productData =
                                          productSnapshot.data!.data()!;
                                      return FutureBuilder(
                                          future: _firestore
                                              .collection('buyer')
                                              .doc(orderDocument
                                                  .orderItems[index].sellerID)
                                              .get(),
                                          builder: (context, sellerSnapshot) {
                                            if (sellerSnapshot.hasData &&
                                                sellerSnapshot.data != null) {
                                              var sellerData =
                                                  sellerSnapshot.data!.data()!;
                                              return CheckoutProductCard(
                                                context: context,
                                                productImageURL:
                                                    productData['imageURL'][0],
                                                productName:
                                                    productData['name'],
                                                netPrice: orderDocument
                                                        .orderItems[index]
                                                        .price *
                                                    orderDocument
                                                        .orderItems[index]
                                                        .quantity,
                                                unitPrice: orderDocument
                                                    .orderItems[index].price,
                                                quantity: orderDocument
                                                    .orderItems[index].quantity,
                                                quantityUnit:
                                                    productData['quantityUnit'],
                                                sellerImageURL:
                                                    sellerData['photoURL'],
                                                sellerName: sellerData['name'],
                                                sellerPhone: sellerData[
                                                            'phone number'] ==
                                                        ""
                                                    ? null
                                                    : sellerData[
                                                        'phone number'],
                                              );
                                            }
                                            return SizedBox.shrink();
                                          });
                                    }
                                    return SizedBox.shrink();
                                  });
                            },
                          ),
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

  Padding CheckoutProductCard({
    required BuildContext context,
    required String productImageURL,
    required String productName,
    required double netPrice,
    required double unitPrice,
    required int quantity,
    required String quantityUnit,
    required String sellerImageURL,
    required String sellerName,
    required String? sellerPhone,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 10,
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
                  flex: 3,
                  child: Container(
                      padding: EdgeInsets.only(left: 5),
                      height: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: productImageURL,
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
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
                            Container(
                              height: 17,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹',
                                    style: TextStyle(
                                      fontSize: 10,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox.shrink()
                                ],
                              ),
                            ),
                            Text(
                              netPrice.toString(),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ' (₹${unitPrice.toString()} x $quantity ${quantityUnit.toLowerCase()})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: sellerImageURL,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    // color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .seller_ucf,
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            sellerName,
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
                              sellerPhone != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          openWhatsAppChat(sellerPhone);
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
                        )
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
