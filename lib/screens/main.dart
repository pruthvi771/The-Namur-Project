import 'package:active_ecommerce_flutter/custom/common_functions.dart';
import 'package:active_ecommerce_flutter/features/profile/enum.dart';
import 'package:active_ecommerce_flutter/features/profile/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
// import 'package:active_ecommerce_flutter/screens/home.dart';
// import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
// import 'package:active_ecommerce_flutter/features/profile/screens/profile.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;
import 'package:provider/provider.dart';
// import 'package:route_transitions/route_transitions.dart';
import 'package:location/location.dart';

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
    //print("i$i");
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
      Cart(
        has_bottomnav: true,
        from_navigation: true,
        counter: counter,
      ),
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
    super.initState();
  }

  Location location = Location();
  late bool _serviceEnabled;
  late permissionHandler.PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<void> checkLocationPermission() async {
    var dataBox = Hive.box<hiveModels.PrimaryLocation>('primaryLocationBox');

    var savedData = dataBox.get('locationData');

    if (savedData != null) {
      print("saved Latitude: ${savedData.latitude}");
      print("saved Longitude: ${savedData.longitude}");
      return;
    }

    print('no saved location data found');

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await permissionHandler.Permission.location.request();
    if (_permissionGranted != permissionHandler.PermissionStatus.granted) {
      return;
    }

    _locationData = await location.getLocation();
    print("new Latitude: ${_locationData.latitude}");
    print("new Longitude: ${_locationData.longitude}");

    var primaryLocation = hiveModels.PrimaryLocation()
      ..id = "locationData"
      ..isAddress = false
      ..latitude = _locationData.latitude as double
      ..longitude = _locationData.longitude as double
      ..address = "";

    await dataBox.put(primaryLocation.id, primaryLocation);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //print("_currentIndex");
        if (_currentIndex != 0) {
          fetchAll();
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          CommonFunctions(context).appExitDialog();
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
                    child: Image.asset(
                      "assets/profile.png",
                      color: _currentIndex == 1
                          ? MyTheme.primary_color
                          : Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context)!.profile_ucf,
                ),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: MyTheme.primary_color,
                          borderRadius: BorderRadius.circular(10),
                          padding: EdgeInsets.all(5),
                        ),
                        badgeAnimation: badges.BadgeAnimation.slide(
                          toAnimate: false,
                        ),
                        child: Image.asset(
                          "assets/cart.png",
                          color: _currentIndex == 2
                              ? MyTheme.primary_color
                              : Color.fromRGBO(153, 153, 153, 1),
                          height: 16,
                        ),
                        badgeContent: Consumer<CartCounter>(
                          builder: (context, cart, child) {
                            return Text(
                              "${cart.cartCounter}",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            );
                          },
                        ),
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
