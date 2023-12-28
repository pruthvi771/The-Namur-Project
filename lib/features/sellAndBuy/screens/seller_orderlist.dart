// translation done

import 'package:flutter/services.dart';
import 'dart:async';
import 'package:active_ecommerce_flutter/features/sellAndBuy/models/order_item.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/seller_order_checkup_screen.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SellerOrderList extends StatefulWidget {
  const SellerOrderList({super.key});

  @override
  State<SellerOrderList> createState() => _SellerOrderListState();
}

class _SellerOrderListState extends State<SellerOrderList> {
  late Future<List<OrderListItem>> sellerOrderList;
  // late Future sellerOrderList;
  late final currentUser;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    currentUser = _firebaseAuth.currentUser!;
    sellerOrderList = _sellerOrderList();
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // Future _sellerOrderList() async {
  Future<List<OrderListItem>> _sellerOrderList() async {
    // try {
    var documentSnapshot = await _firestore
        .collection('orders')
        .where('sellers', arrayContains: currentUser.uid)
        .get();

    List<OrderListItem> sellerOrderList = [];

    if (documentSnapshot.docs.isNotEmpty) {
      // You can loop through all documents if needed
      for (var doc in documentSnapshot.docs) {
        // print(doc.data());
        sellerOrderList.add(OrderListItem(
          orderID: doc.id,
          totalAmount: doc.data()['totalAmount'].toDouble(),
          status: doc.data()['status'].toString(),
          timestamp: doc.data()['orderDate'],
        ));
      }
    } else {
      print('No orders found for this user.');
    }

    // for (var order in sellerOrderList) {
    //   print(order.toMap());
    // }

    return sellerOrderList;
    // } catch (error) {
    //   print('Error fetching orders: $error');
    //   throw error;
    // }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      sellerOrderList = _sellerOrderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.orders_ucf,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins')),
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
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
            future: sellerOrderList,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                List<OrderListItem> sellerOrderList =
                    snapshot.data as List<OrderListItem>;
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   color: MyTheme.green_light,
                    //   height: 100,
                    // ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        // color: MyTheme.green_lighter,

                        child: sellerOrderList.length == 0
                            ? Container(
                                child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.no_orders_yet,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ))
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.grey[100],
                                ),
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Text(
                                            AppLocalizations.of(context)!
                                                .order_id,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            AppLocalizations.of(context)!
                                                .date_ucf,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            AppLocalizations.of(context)!
                                                .status,
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            AppLocalizations.of(context)!.total,
                                          ),
                                        ),
                                      ],
                                      // rows: <DataRow>[],
                                      rows: List.generate(
                                          sellerOrderList.length, (index) {
                                        DateTime date = DateTime.parse(
                                            sellerOrderList[index]
                                                .timestamp
                                                .toDate()
                                                .toString());
                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Text(
                                                sellerOrderList[index].orderID,
                                                style: TextStyle(
                                                  color: MyTheme.accent_color,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins',
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              onTap: () {
                                                print(sellerOrderList[index]
                                                    .orderID);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SellerOrderCheckupScreen(
                                                            orderID:
                                                                sellerOrderList[
                                                                        index]
                                                                    .orderID,
                                                            sellerID:
                                                                currentUser.uid,
                                                          )),
                                                );
                                              },
                                            ),
                                            DataCell(
                                              Text(
                                                '${date.day}-${date.month}-${date.year}',
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                sellerOrderList[index].status,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                sellerOrderList[index]
                                                    .totalAmount
                                                    .toString(),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
