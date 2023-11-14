import 'dart:convert';

import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:flutter/widgets.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/custom/common_functions.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, Map<String, int>> productMap = {};

  @override
  void initState() {
    // TODO: implement initState
    currentUser = _firebaseAuth.currentUser!;
    totalAmountFuture = _getTotalAmount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final currentUser;

  double totalAmount = 0;

  Future _getCartData() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(currentUser.uid)
        .get();

    return userSnapshot;
  }

  late Future<double?> totalAmountFuture;

  Future<double?> _getTotalAmount() async {
    // final cartDoc = await FirebaseFirestore.instance
    //     .collection('orders')
    //     .where('sellers', arrayContains: 'abc')
    //     .get();

    final cartDoc = await FirebaseFirestore.instance
        .collection('orders')
        .where('sellers.items.seller', arrayContains: 'abc')
        .get();

    print(cartDoc.docs.length);
    print(cartDoc.docs[0].data());

    return 1.0;
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
            title: Text(AppLocalizations.of(context)!.checkout_ucf,
                style: TextStyle(
                    color: MyTheme.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins')),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          'Order Details',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Code',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'jsf4kHIf8G3KFBW',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '1 November 2021',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '1000',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Confirmed',
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
                    'Ordered Products',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //   child: Column(
                //     children: [
                //       Container(
                //         height: 120,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(7),
                //           color: Colors.grey[100],
                //         ),
                //         child: Row(
                //           children: [
                //             Expanded(
                //               flex: 2,
                //               child: Container(
                //                 height: double.infinity,
                //                 color: Colors.red,
                //                 child: CachedNetworkImage(
                //                   imageUrl:
                //                       'https://m.media-amazon.com/images/M/MV5BNzQyODYzNTAxNV5BMl5BanBnXkFtZTgwMDcxNzM2MjI@._V1_.jpg',
                //                   fit: BoxFit.cover,
                //                 ),
                //               ),
                //             ),
                //             Expanded(
                //               flex: 3,
                //               child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Column(
                //                   children: [
                //                     Text(
                //                       'Cow from goat',
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 17,
                //                       ),
                //                     ),
                //                     Text(
                //                       '₹1562',
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 17,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //       Container(
                //         height: 120,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(7),
                //           color: MyTheme.light_grey,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                CheckoutProductCard(context),
                CheckoutProductCard(context),
                CheckoutProductCard(context),
                CheckoutProductCard(context),
                CheckoutProductCard(context),
              ],
            ),
          ),
        ));
  }

  Padding CheckoutProductCard(BuildContext context) {
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
                          imageUrl:
                              'https://m.media-amazon.com/images/M/MV5BNzQyODYzNTAxNV5BMl5BanBnXkFtZTgwMDcxNzM2MjI@._V1_.jpg',
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cow from Goat',
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
                                  '1230',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  ' (₹1230 x 10 units)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    // fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                                      imageUrl:
                                          'https://m.media-amazon.com/images/M/MV5BNzQyODYzNTAxNV5BMl5BanBnXkFtZTgwMDcxNzM2MjI@._V1_.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    // color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Seller',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Harshit RV',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  size: 35,
                                  color: Color(0xFF25d366),
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
