import 'dart:io';

import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/cart.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'my_account/my_account.dart';

class Main extends StatefulWidget {
  Main({Key? key, go_back = true}) : super(key: key);

  late bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  //int _cartCount = 0;

  BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();

  CartCounter counter = CartCounter();

  var _children = [];

  final AuthRepository authRepository = AuthRepository();
  var currentUser;

  fetchAll() {
    getCartCount();
  }

  void onTapped(int i) {
    fetchAll();
    /* if (!is_logged_in.$ && (i == 2)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    if (i == 3) {
      app_language_rtl.$!
          ? slideLeftWidget(newPage: Profile(), context: context)
          : slideRightWidget(newPage: Profile(), context: context);
      return;
    }*/

    setState(() {
      _currentIndex = i;
    });
    //
  }

  getCartCount() async {
    Provider.of<CartCounter>(context, listen: false).getCount();
  }

  void initState() {
    _children = [
      //  Home(),
      CategoryList(
        is_base_category: true,
      ),
      MyAccount(),
      // Cart(
      //   has_bottomnav: true,
      //   from_navigation: true,
      //   counter: counter,
      // ),

      CartScreen(),
      Address(
          //   is_base_category: true,
          ),
    ];
    fetchAll();
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    // checkLocationPermission();
    currentUser = authRepository.currentUser!;
    super.initState();
  }

  bool isExitDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //
        if (_currentIndex != 0) {
          fetchAll();
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          if (!isExitDialogShowing) {
            isExitDialogShowing = true;
            // CommonFunctions(context).appExitDialog();
            showDialog(
              context: context,
              builder: (context) => Directionality(
                textDirection:
                    app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
                child: AlertDialog(
                  content: Text(
                      AppLocalizations.of(context)!.do_you_want_close_the_app),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                        },
                        child: Text(AppLocalizations.of(context)!.yes_ucf)),
                    TextButton(
                        onPressed: () {
                          isExitDialogShowing = false;
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.no_ucf)),
                  ],
                ),
              ),
            );
          }
        }
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          body: _children[_currentIndex],
          bottomNavigationBar: SizedBox(
            height: 70,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: onTapped,
              currentIndex: _currentIndex,
              backgroundColor: Colors.white.withOpacity(0.95),
              unselectedItemColor: Color.fromRGBO(168, 175, 179, 1),
              selectedItemColor: MyTheme.primary_color,
              selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: MyTheme.primary_color,
                  fontSize: 12),
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(168, 175, 179, 1),
                  fontSize: 12),
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        "assets/home.png",
                        color: _currentIndex == 0
                            ? MyTheme.primary_color
                            : Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                    ),
                    label: AppLocalizations.of(context)!.home_ucf),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    // child: Image.asset(
                    //   "assets/profile.png",
                    //   color: _currentIndex == 1
                    //       ? MyTheme.primary_color
                    //       : Color.fromRGBO(153, 153, 153, 1),
                    //   height: 16,
                    // ),
                    child: Icon(Icons.person_outlined),
                  ),
                  label: AppLocalizations.of(context)!.my_account,
                ),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        "assets/cart.png",
                        color: _currentIndex == 2
                            ? MyTheme.primary_color
                            : Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                    ),
                    label: AppLocalizations.of(context)!.cart_ucf),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        "assets/location.png",
                        color: _currentIndex == 3
                            ? MyTheme.primary_color
                            : Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                    ),
                    label: AppLocalizations.of(context)!.address_ucf),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
