import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/checkout_screen.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_event.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_state.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, Map<String, int>> productMap = {};

  @override
  void initState() {
    // TODO: implement initState
    currentUser = _firebaseAuth.currentUser!;
    // totalAmountFuture = _getTotalAmount();
    initialGetCartData = _getCartData(nullData: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final currentUser;

  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  double totalAmount = 0;

  late Future initialGetCartData;

  Future _getCartData({required bool nullData}) async {
    if (nullData) {
      return 0;
    }
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(currentUser.uid)
        .get();

    return userSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartProductDeleted) {
            setState(() {
              initialGetCartData = _getCartData(nullData: false);
            });
          }
        },
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
            title: Text(
              AppLocalizations.of(context)!.shopping_cart_ucf,
              style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins',
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      CheckoutRepository().reduceProductQuantity(
                        productId: 'CWrkrgqV3X1rHoAy1EVr',
                        quantityToReduce: 22,
                      );
                    },
                    child: Text('mello'),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: initialGetCartData,
                      builder: (context, cartSnapshot) {
                        if (cartSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (cartSnapshot.hasError) {
                          return Text('Error: ${cartSnapshot.error}');
                        } else if (cartSnapshot.hasData &&
                            cartSnapshot.data == 0) {
                          return Center(child: CircularProgressIndicator());
                        } else if (!cartSnapshot.hasData ||
                            !cartSnapshot.data!.exists) {
                          return Column(
                            children: [
                              SizedBox(height: 200),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Cart is empty',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckoutScreen(
                                                orderID: '12345',
                                              )),
                                    );
                                  },
                                  child: Text('Checkout')),
                            ],
                          );
                        } else {
                          var productsInCart =
                              cartSnapshot.data!['products'] ?? [];
                          // print(productsInCart);

                          if (productsInCart.isEmpty) {
                            return Column(
                              children: [
                                SizedBox(height: 200),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Cart is empty',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          // Extract product IDs from the cart
                          List productIds = productsInCart
                              .map((product) => product['productId'].toString())
                              .toList();

                          return ListView.builder(
                            itemCount: productIds.length,
                            itemBuilder: ((context, index) {
                              return StreamBuilder(
                                  stream: productsCollection
                                      .where(FieldPath.documentId,
                                          isEqualTo: productIds[index])
                                      .snapshots(),
                                  builder: (context, productSnapshot) {
                                    if (productSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (productSnapshot.hasError) {
                                      return Text(
                                          'Error: ${productSnapshot.error}');
                                    } else if (!productSnapshot.hasData ||
                                        productSnapshot.data!.docs.isEmpty) {
                                      return Text('No products available');
                                    } else {
                                      var productsData =
                                          productSnapshot.data!.docs;
                                      var productDocument = productsData[0];

                                      var productData = productDocument.data()
                                          as Map<String, dynamic>;

                                      var productInCart =
                                          productsInCart.firstWhere(
                                              (product) =>
                                                  product['productId'] ==
                                                  productDocument.id,
                                              orElse: () => null);

                                      if (productInCart != null) {
                                        int quantity =
                                            productInCart['quantity'];
                                        String productName =
                                            productData['name'];
                                        List productImageUrl =
                                            productData['imageURL'];
                                        double productPrice =
                                            productData['price'];
                                        var productId = productDocument.id;

                                        return StreamBuilder(
                                            stream: cartCollection
                                                .where(FieldPath.documentId,
                                                    isEqualTo: currentUser.uid)
                                                .snapshots(),
                                            builder: (context, cartSnapshot) {
                                              if (cartSnapshot.hasData) {
                                                var currentProduct =
                                                    cartSnapshot.data!.docs[0]
                                                        ['products'];

                                                var currentQuantity =
                                                    currentProduct
                                                        .firstWhere((product) =>
                                                            product[
                                                                'productId'] ==
                                                            productId)['quantity'];

                                                return CartItem(
                                                  context: context,
                                                  name: productName,
                                                  imageURL: productImageUrl,
                                                  price: productPrice,
                                                  quantityUnit: productData[
                                                      'quantityUnit'],
                                                  description: productData[
                                                      'description'],
                                                  subSubCategory: productData[
                                                      'subSubCategory'],
                                                  productId: productId,
                                                  quantity: currentQuantity,
                                                  onTap: () {
                                                    if (currentQuantity == 1) {
                                                      setState(() {
                                                        initialGetCartData =
                                                            _getCartData(
                                                                nullData: true);
                                                      });
                                                    }
                                                  },
                                                );
                                              } else {
                                                return SizedBox.shrink();
                                              }
                                            });
                                      }
                                      return SizedBox.shrink();
                                    }
                                  });
                            }),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 140,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CheckoutWidget(
                  currentUser: currentUser,
                  onTap: () {
                    setState(() {
                      initialGetCartData = _getCartData(nullData: false);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutWidget extends StatefulWidget {
  const CheckoutWidget({
    super.key,
    required this.currentUser,
    required this.onTap,
  });

  final User currentUser;
  final Function() onTap;

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  void initState() {
    totalAmountFuture = _getTotalAmount();
    super.initState();
  }

  late Future<double?> totalAmountFuture;

  Future<double?> _getTotalAmount() async {
    final cartDoc = await FirebaseFirestore.instance
        .collection('cart')
        .doc(widget.currentUser.uid)
        .get();

    if (!cartDoc.exists) {
      print('Cart not found for user: ${widget.currentUser.uid}');
      return null;
    }

    final List<Map<String, dynamic>> products =
        List<Map<String, dynamic>>.from(cartDoc.data()?['products']);

    double totalAmount = 0;

    for (final product in products) {
      final productId = product['productId'] as String;
      final quantity = product['quantity'] as int;

      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        final price = productDoc.data()?['price'] as double;
        final productTotal = price * quantity;
        totalAmount += productTotal;
      } else {
        print('Product not found for ID: $productId');
      }
    }

    // Step 4: Calculate the total amount
    print('Total Amount: $totalAmount');

    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        // if (state is )
        if (state is CartUpdated) {
          setState(() {
            totalAmountFuture = _getTotalAmount();
          });
        }
        if (state is CartProductDeleted) {
          setState(() {
            totalAmountFuture = _getTotalAmount();
          });
        }
      },
      child: FutureBuilder(
          future: totalAmountFuture,
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return SizedBox.shrink();
            // }
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data != 0) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  height: 185,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 4),
                    child: Column(
                      children: [
                        // total amount
                        SizedBox(height: 5),
                        Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: MyTheme.green_light),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .total_amount_ucf,
                                  style: TextStyle(
                                      color: MyTheme.dark_font_grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text('₹ ${snapshot.data}',
                                    style: TextStyle(
                                        color: MyTheme.primary_color,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
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
                              totalAmountFuture = _getTotalAmount();
                              widget.onTap();
                            }
                            if (state is CheckoutError) {
                              ToastComponent.showDialog(state.message,
                                  gravity: Toast.center,
                                  duration: Toast.lengthLong);
                              BlocProvider.of<CheckoutBloc>(context).add(
                                CheckoutInitialEventRequested(),
                              );
                            }
                            if (state is NotEnoughQuantityError) {
                              ToastComponent.showDialog(
                                  'Only ${state.availableQuantity} units of ${state.productName} available',
                                  gravity: Toast.center,
                                  duration: Toast.lengthLong);
                              BlocProvider.of<CheckoutBloc>(context).add(
                                CheckoutInitialEventRequested(),
                              );
                            }
                          },
                          child: BlocBuilder<CheckoutBloc, CheckoutState>(
                            builder: (context, state) {
                              if (state is CheckoutLoading) {
                                return Container(
                                  height: 50,
                                  margin: EdgeInsets.only(top: 10),
                                  width:
                                      (MediaQuery.of(context).size.width - 100),
                                  decoration: BoxDecoration(
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      elevation:
                                          MaterialStateProperty.all<double>(0),
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              MyTheme.primary_color),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                );
                              }
                              return Container(
                                height: 50,
                                margin: EdgeInsets.only(top: 10),
                                width:
                                    (MediaQuery.of(context).size.width - 100),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            MyTheme.primary_color),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .proceed_to_shipping_ucf,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<CheckoutBloc>(context).add(
                                      CheckoutRequested(
                                          userID: widget.currentUser.uid),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }
            return SizedBox.shrink();
          }),
    );
  }
}

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.context,
    required this.name,
    required this.imageURL,
    required this.price,
    required this.quantityUnit,
    required this.description,
    required this.subSubCategory,
    required this.productId,
    required this.quantity,
    required this.onTap,
  });

  final BuildContext context;
  final String name;
  final List imageURL;
  final double price;
  final String quantityUnit;
  final String description;
  final String subSubCategory;
  final String productId;
  final int quantity;
  final void Function() onTap;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void initState() {
    BlocProvider.of<CartBloc>(widget.context).add(
      CheckIfAlreadyInCartRequested(productId: widget.productId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        // bottom: 8,
      ),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1, color: MyTheme.medium_grey.withOpacity(0.5))),
          height: 120,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 8),
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
                      child:
                          widget.imageURL.isEmpty || widget.imageURL.length == 0
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.imageURL[0],
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
                          widget.name,
                          // 'skgknkl kgsne ksngkla lkgnlkang lkenglkg',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${widget.price.toInt()}',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  ' per ${widget.quantityUnit == "Units" ? 'unit' : widget.quantityUnit}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Text(widget.quantity.toString()),
                        // Text(widget.productId),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        MyTheme.primary_color, // Border color
                                    width: 2.0, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Border radius
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    widget.onTap();
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateCartQuantityRequested(
                                        productId: widget.productId,
                                        currentQuantity: widget.quantity,
                                        type: UpdateCartQuantityType.decrement,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                    elevation: 0,
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: MyTheme.primary_color,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  widget.quantity.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 20,
                                      fontFamily: 'Poppins'),
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        MyTheme.primary_color, // Border color
                                    width: 2.0, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Border radius
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    BlocProvider.of<CartBloc>(context).add(
                                      UpdateCartQuantityRequested(
                                        productId: widget.productId,
                                        currentQuantity: widget.quantity,
                                        type: UpdateCartQuantityType.increment,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                    elevation: 0,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: MyTheme.primary_color,
                                  ),
                                ),
                              ),
                            ],
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
