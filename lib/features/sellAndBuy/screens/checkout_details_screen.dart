// translation done.

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/checkout_address_add.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/checkout_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_state.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class CheckoutDetails extends StatefulWidget {
  final String uid;
  final double totalPrice;

  const CheckoutDetails({
    Key? key,
    required this.uid,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<CheckoutDetails> createState() => _CheckoutDetailsState();
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  late Future<List<CheckoutAddress>> _addressListFuture;
  CheckoutAddress? selectedAddress;
  int? selectedAddressIndex;

  Future<List<CheckoutAddress>> getUserAddresses({required String uid}) async {
    List<CheckoutAddress> addressList = [];

    var docSnapshot =
        await FirebaseFirestore.instance.collection('buyer').doc(uid).get();

    var docData = docSnapshot.data() as Map<String, dynamic>;
    // print(docData);

    if (docData['address'] == null || docData['address'].isEmpty) {
      return addressList;
    }
    docData['address'].forEach((address) {
      // print(address['houseNumber']);
      // print(address['streetName']);
      // print(address['city']);
      // print(address['state']);
      // print(address['pincode']);
      // print(address['landmark']);
      addressList.add(
        CheckoutAddress(
          houseNumber: address['houseNumber'],
          streetName: address['streetName'],
          city: address['city'],
          state: address['state'],
          pincode: address['pincode'],
          landmark: address['landmark'],
        ),
      );
    });

    return addressList;
  }

  deleteAddress({required int index}) {
    return () async {
      setState(() {
        selectedAddress = null;
        selectedAddressIndex = null;
      });
      var docSnapshot = await FirebaseFirestore.instance
          .collection('buyer')
          .doc(widget.uid)
          .get();

      var docData = docSnapshot.data() as Map<String, dynamic>;

      List addressList = docData['address'];

      addressList.removeAt(index);

      await FirebaseFirestore.instance
          .collection('buyer')
          .doc(widget.uid)
          .update({'address': addressList});

      setState(() {
        _addressListFuture = getUserAddresses(uid: widget.uid);
      });
    };
  }

  void initState() {
    super.initState();
    _addressListFuture = getUserAddresses(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(
          // 'Filters',
          AppLocalizations.of(context)!.checkout_ucf,
          style: TextStyle(
              color: MyTheme.white,
              fontWeight: FontWeight.w500,
              letterSpacing: .5,
              fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: .5,
                    fontFamily: 'Poppins'),
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _addressListFuture = getUserAddresses(uid: widget.uid);
          });
        },
        child: ListView(
          children: [
            TotalAmountSection(context),
            AddressSection(context),
            RazorpaySection(context),
            CodSection(context),
          ],
        ),
      ),
    );
  }

  Padding AddressSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
          // height: 250,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              // heading
              Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.choose_address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .5,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutAddressAdd(
                              uid: widget.uid,
                            ),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.add_address),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.primary_color),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              FutureBuilder(
                  future: _addressListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CheckoutAddress> addressList =
                          snapshot.data as List<CheckoutAddress>;
                      if (addressList.isEmpty) {
                        return Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.no_address_added,
                              style: TextStyle(
                                fontSize: 16,
                                color: MyTheme.font_grey,
                                fontWeight: FontWeight.w500,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: List.generate(
                          addressList.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                print('ge $index');
                              },
                              child: Container(
                                // color: Colors.red[100],
                                height: 50,
                                child: Row(
                                  children: [
                                    Radio(
                                        value: selectedAddressIndex == index
                                            ? 1
                                            : 0,
                                        groupValue: 1,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedAddressIndex = index;
                                            selectedAddress =
                                                addressList[index];
                                          });
                                        }),
                                    Expanded(
                                      child: Text(
                                        '${addressList[index].houseNumber}, ${addressList[index].streetName}, ${addressList[index].city}, ${addressList[index].state}, ${addressList[index].pincode}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: MyTheme.font_grey,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: deleteAddress(index: index),
                                      icon: FaIcon(
                                        FontAwesomeIcons.trash,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Container(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding TotalAmountSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.total_amount_ucf,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .5,
                ),
              ),
              Spacer(),
              Text(
                '₹ ${widget.totalPrice}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding RazorpaySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
          // height: 250,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.pay_via} Net Banking, Card or UPI',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ToastComponent.showDialog(
                      AppLocalizations.of(context)!.coming_soon,
                      gravity: Toast.center,
                      duration: Toast.lengthLong);
                },
                child: Container(
                  height: 40,
                  // color: Colors.red[100],
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        height: 30,
                        imageUrl: imageForNameCloud['razorpay']!,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'Razorpay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding CodSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
          // height: 250,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: Column(
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.pay_via +
                            ' ' +
                            AppLocalizations.of(context)!.cash_on_delivery_ucf,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocListener<CheckoutBloc, CheckoutState>(
                listener: (context, state) {
                  if (state is CheckoutCompleted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                                orderID: state.orderId,
                              )),
                    );
                  }
                  if (state is CheckoutError) {
                    ToastComponent.showDialog(state.message,
                        gravity: Toast.center, duration: Toast.lengthLong);
                    BlocProvider.of<CheckoutBloc>(context).add(
                      CheckoutInitialEventRequested(),
                    );
                  }
                  if (state is NotEnoughQuantityError) {
                    if (state.availableQuantity == 0) {
                      ToastComponent.showDialog(
                          AppLocalizations.of(context)!
                              .product_is_out_of_stock(state.productName),
                          gravity: Toast.center,
                          duration: Toast.lengthLong);
                    } else {
                      ToastComponent.showDialog(
                          // 'Only ${state.availableQuantity} units of ${state.productName} available',
                          AppLocalizations.of(context)!
                              .only_some_quantity_left_for_product(
                                  state.productName, state.availableQuantity),
                          gravity: Toast.center,
                          duration: Toast.lengthLong);
                    }
                    BlocProvider.of<CheckoutBloc>(context).add(
                      CheckoutInitialEventRequested(),
                    );
                  }
                },
                child: BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    if (state is CheckoutLoading) {
                      return Container(
                        height: 40,
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        if (selectedAddress == null) {
                          ToastComponent.showDialog(
                              AppLocalizations.of(context)!
                                  .select_address_to_continue,
                              gravity: Toast.center,
                              duration: Toast.lengthLong);
                          return;
                        }

                        BlocProvider.of<CheckoutBloc>(context).add(
                          CreateOrderRequested(
                            userID: widget.uid,
                            address: selectedAddress!,
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        // color: Colors.red[100],
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              height: 30,
                              imageUrl: imageForNameCloud['cod']!,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'COD',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutAddress {
  String houseNumber;
  String streetName;
  String state;
  String pincode;
  String city;
  String? landmark;

  CheckoutAddress({
    required this.houseNumber,
    required this.streetName,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
  });

  toMap() {
    return {
      'houseNumber': houseNumber,
      'streetName': streetName,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
    };
  }
}
