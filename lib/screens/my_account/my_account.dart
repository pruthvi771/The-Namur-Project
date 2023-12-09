import 'dart:async';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/features/auth/models/auth_user.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/models/userdata.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/cart.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/my_purchases.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/seller_orderlist.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../features/profile/screens/profile.dart';

import '../notification/notification_screen.dart';

class MyAccount extends StatefulWidget {
  MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  HomePresenter homeData = HomePresenter();
  ScrollController _mainScrollController = ScrollController();

  late BuildContext loadingcontext;
  FirestoreRepository firestoreRepository = FirestoreRepository();
  late Future<SellerDataForFriendsScreen> _sellerUserDataFuture;
  var user = null;

  @override
  void initState() {
    super.initState();
    _sellerUserDataFuture = _getSellerUserData();
    if (user != null) {}
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<SellerDataForFriendsScreen> _getSellerUserData() async {
    AuthUser user = AuthRepository().currentUser!;
    return firestoreRepository.getSellerData(userId: user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
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
            AppLocalizations.of(context)!.acccount_ucf,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins'),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: MyTheme.white, width: 1),
                    ),
                    child: FutureBuilder(
                        future: _sellerUserDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            var sellerData =
                                snapshot.data as SellerDataForFriendsScreen;
                            return ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              child: (sellerData.photoURL == null ||
                                      sellerData.photoURL == '')
                                  ? Image.asset(
                                      "assets/default_profile2.png",
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: sellerData.photoURL!,
                                      fit: BoxFit.cover,
                                    ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: buildCountersRow(),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: buildBottomVerticalCardList(),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomVerticalCardList() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBottomVerticalCardListItem(
            iconWidget: true,
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color: MyTheme.white,
            ),
            label: LangText(context).local!.notification_ucf,
            color: Color(0xff9747FF),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return NotificationScreen();
                }),
              );
            },
          ),
          buildBottomVerticalCardListItem(
            img: "assets/orders.png",
            label: LangText(context).local!.purchase_ucf,
            color: Color(0xff69BB36),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return PurchaseHistoryScreen();
                }),
              );
            },
          ),
          buildBottomVerticalCardListItem(
            iconWidget: true,
            icon: FaIcon(
              FontAwesomeIcons.tableColumns,
              color: MyTheme.white,
            ),
            label: LangText(context).local!.seller_platform_ucf,
            color: Color.fromARGB(255, 54, 187, 143),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SellerOrderList();
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Container buildBottomVerticalCardListItem({
    String? img,
    FaIcon? icon,
    required String label,
    required Color color,
    Function()? onPressed,
    bool isDisable = false,
    bool iconWidget = false,
  }) {
    return Container(
      height: 60,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            alignment: Alignment.center,
            padding: EdgeInsets.zero),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: CircleAvatar(
                backgroundColor: color,
                radius: 25,
                child: iconWidget
                    ? icon
                    : Image.asset(
                        img!,
                        height: 25,
                        width: 25,
                        color: isDisable ? MyTheme.white : MyTheme.white,
                      ),
                // child: Icon(Icons.notifications),
                // child: Icon(Icons.notifications),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .5,
                  color: isDisable ? Color(0xff2F2D2D) : Color(0xff2F2D2D),
                  fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }

  openCart() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CartScreen();
    }));
  }

  openprofile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Profile();
    }));
  }

  Widget buildCountersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildCountersRowItem(
          FaIcon(FontAwesomeIcons.cartShopping),
          AppLocalizations.of(context)!.cart_ucf,
          openCart,
        ),
        buildCountersRowItem(
          Icon(
            Icons.person,
            size: 30,
          ),
          AppLocalizations.of(context)!.profile__ucf,
          openprofile,
        ),
      ],
    );
  }

  Widget buildCountersRowItem(
      Widget icon, String title, VoidCallback function) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      width: DeviceInfo(context).width! / 3.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyTheme.green_light,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: function,
            icon: icon,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
