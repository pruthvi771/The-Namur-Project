import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/checkout_screen.dart';
import 'package:active_ecommerce_flutter/utils/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  PurchaseHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  Map<String, Map<String, int>> productMap = {};

  @override
  void initState() {
    currentUser = _firebaseAuth.currentUser!;
    super.initState();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final currentUser;

  Stream<QuerySnapshot> getOrderStream(String buyerId) {
    return _firestore
        .collection('orders')
        .where('buyer', isEqualTo: buyerId)
        .orderBy('orderDate', descending: true)
        // .orderBy('status', descending: true)
        .snapshots();
  }

  late Future<OrderDocument> orderDocDataFuture;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          // drawer: const MainDrawer(),
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
            title: Text(AppLocalizations.of(context)!.purchase_history_ucf,
                style: TextStyle(
                    color: MyTheme.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins')),
            centerTitle: true,
          ),
          body: StreamBuilder(
            stream: getOrderStream(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // if (snapshot.hasError) {
              //   return Text('Error: ${snapshot.error}');
              // }

              if (!snapshot.hasData || snapshot.data == null) {
                // Handle the case where no data is available
                return Center(
                    child: Text(
                  AppLocalizations.of(context)!.could_not_fetch_order_details,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ));
              }

              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              return documents.length == 0
                  ? Center(
                      child: Text(
                      AppLocalizations.of(context)!.no_orders_yet,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        String documentId = documents[index].id;
                        Map<String, dynamic> orderData =
                            documents[index].data() as Map<String, dynamic>;

                        String nameToDisplay = '';
                        for (var item in orderData['items']) {
                          if (item == orderData['items'].last) {
                            nameToDisplay += item['name'];
                            break;
                          }
                          nameToDisplay += item['name'] + ', ';
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(
                                        orderID: documentId,
                                        newOrder: false,
                                      )),
                            );
                          },
                          child: PreviousOrderCard(
                              context: context,
                              title: nameToDisplay,
                              // title:
                              //     'alkfnaklngvangv algkagv aelkga glekhawoi tmtIWH i3hroIR WFNQWNF ',
                              totalPrice: orderData['totalAmount'].toDouble(),
                              orderID: documentId.toString(),
                              orderStatus: orderData['status'],
                              orderTime: orderData['orderDate']),
                        );
                      },
                    );
            },
          ),
        ));
  }

  Padding PreviousOrderCard({
    required BuildContext context,
    required String title,
    required double totalPrice,
    required String orderID,
    required String orderStatus,
    required Timestamp orderTime,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        left: 8,
        right: 8,
        bottom: 5,
      ),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
              // color: MyTheme.green_light,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
          height: 115,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Container(
                            height: 17,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            totalPrice.toInt().toString(),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('#$orderID',
                          //     style: TextStyle(
                          //       fontSize: 13,
                          //       fontWeight: FontWeight.w400,
                          //     )),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          Text(
                              '${formatDateWithYear(orderTime.toDate().toString().substring(0, 10))} at ${orderTime.toDate().toString().substring(11, 16)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          color: MyTheme.green_lighter,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(orderStatus),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
