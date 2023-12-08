import 'dart:async';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/cart.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/my_purchases.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/seller_orderlist.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/screens/currency_change.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/drawer/drawer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../features/profile/screens/profile.dart';
import '../../repositories/auth_repository.dart';

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

  var user = null;

  @override
  void initState() {
    super.initState();

    if (user != null) {}
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
  }

  onPopped(value) async {
    reset();
  }

  deleteAccountReq() async {
    loading();
    var response = await AuthRepository().getAccountDeleteResponse();

    if (response.result!) {
      AuthHelper().clearUserData();
      Navigator.pop(loadingcontext);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Main();
      }), (route) => false);
    }
    ToastComponent.showDialog(response.message!);
  }

  String counterText(String? txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    if (default_length > txt!.length) {
      newtxt = leading_zeros + newtxt;
    }

    return newtxt;
  }

  reset() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: buildView(context),
    );
  }

  Widget buildView(context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            key: homeData.scaffoldKey,
            drawer: const MainDrawer(),
            backgroundColor: Colors.transparent,
            appBar: buildCustomAppBar(context),
            body: buildBody(),
          ),
        ],
      ),
    );
  }

  RefreshIndicator buildBody() {
    return RefreshIndicator(
      color: MyTheme.white,
      backgroundColor: MyTheme.primary_color,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: buildBodyChildren(),
    );
  }

  CustomScrollView buildBodyChildren() {
    return CustomScrollView(
      controller: _mainScrollController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(right: 70.0, left: 70, top: 20),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: MyTheme.white, width: 1),
                ),
                child: (user != null)
                    ? ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: "${avatar_original.$}",
                          fit: BoxFit.fill,
                        ))
                    : Image.asset(
                        'assets/profile_placeholder.png',
                        height: 150,
                        width: 150,
                        fit: BoxFit.fitHeight,
                      ),
              ),
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
          ]),
        )
      ],
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 20,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: IconButton(
                          onPressed: () {
                            homeData.scaffoldKey.currentState?.openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: MyTheme.white,
                            size: 25,
                          )),
                    ),
                  ),
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.acccount_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
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
          //TODO: add notification icon
          buildBottomVerticalCardListItem(
              "assets/notification.png",
              LangText(context).local!.notification_ucf,
              Color(0xff9747FF), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NotificationScreen();
            }));
          }),
          //TODO: add PURCHASE history icon
          buildBottomVerticalCardListItem(
              "assets/wallet.png",
              LangText(context).local!.purchase_ucf,
              Color(0xff69BB36), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PurchaseHistoryScreen();
            }));
          }),
          //TODO: add SELLER PLATFORM icon
          buildBottomVerticalCardListItem(
              "assets/wallet.png",
              LangText(context).local!.seller_platform_ucf,
              Color(0xff69BB36), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SellerOrderList();
            }));
          }),
        ],
      ),
    );
  }

  Container buildBottomVerticalCardListItem(String img, String label, color,
      {Function()? onPressed, bool isDisable = false}) {
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
                child: Image.asset(
                  img,
                  height: 25,
                  width: 25,
                  color: isDisable ? MyTheme.white : MyTheme.white,
                ),
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

  Widget buildHorizontalSettings() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildHorizontalSettingItem(true, "assets/language.png",
              AppLocalizations.of(context)!.language_ucf, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChangeLanguage();
                },
              ),
            );
          }),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CurrencyChange();
              }));
            },
            child: Column(
              children: [
                Image.asset(
                  "assets/currency.png",
                  height: 16,
                  width: 16,
                  color: MyTheme.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.currency_ucf,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: MyTheme.white,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          buildHorizontalSettingItem(
              (user != null),
              "assets/edit.png",
              AppLocalizations.of(context)!.edit_profile_ucf,
              (user != null)
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProfileEdit();
                      })).then((value) {
                        onPopped(value);
                      });
                    }
                  : () => showLoginWarning()),
          buildHorizontalSettingItem(
              (user != null),
              "assets/location.png",
              AppLocalizations.of(context)!.address_ucf,
              (user != null)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Address();
                          },
                        ),
                      );
                    }
                  : () => showLoginWarning()),
        ],
      ),
    );
  }

  InkWell buildHorizontalSettingItem(
      bool isLogin, String img, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            img,
            height: 16,
            width: 16,
            color: isLogin ? MyTheme.white : MyTheme.blue_grey,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10,
                color: isLogin ? MyTheme.white : MyTheme.blue_grey,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  showLoginWarning() {
    return ToastComponent.showDialog(
        AppLocalizations.of(context)!.you_need_to_log_in,
        gravity: Toast.center,
        duration: Toast.lengthLong);
  }

  deleteWarningDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                LangText(context).local!.delete_account_warning_title,
                style: TextStyle(fontSize: 15, color: MyTheme.dark_font_grey),
              ),
              content: Text(
                LangText(context).local!.delete_account_warning_description,
                style: TextStyle(fontSize: 13, color: MyTheme.dark_font_grey),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      pop(context);
                    },
                    child: Text(LangText(context).local!.no_ucf)),
                TextButton(
                    onPressed: () {
                      pop(context);
                      deleteAccountReq();
                    },
                    child: Text(LangText(context).local!.yes_ucf))
              ],
            ));
  }

  Container buildSettingAndAddonsHorizontalMenuItem(
      String img, String text, Function() onTap, color) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      width: DeviceInfo(context).width! / 4,
      child: InkWell(
        onTap: is_logged_in.$
            ? onTap
            : () {
                showLoginWarning();
              },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 25,
              child: Image.asset(
                img,
                scale: .1,
                width: 25,
                height: 25,
                color: is_logged_in.$ ? MyTheme.white : MyTheme.white,
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                  color: is_logged_in.$
                      ? MyTheme.dark_font_grey
                      : MyTheme.medium_grey_50,
                  fontSize: 12),
            )
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
        buildCountersRowItem('assets/cart.png',
            AppLocalizations.of(context)!.cart_ucf, openCart),
        buildCountersRowItem('assets/profile.png',
            AppLocalizations.of(context)!.profile__ucf, openprofile),
      ],
    );
  }

  Widget buildCountersRowItem(
      String asset, String title, VoidCallback function) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 4),
        width: DeviceInfo(context).width! / 3.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyTheme.green_light,
        ),
        child: Column(
          children: [
            IconButton(
              onPressed: function,
              icon: Image.asset(
                asset,
                height: 30,
                color: Colors.black54,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context)!.please_wait_ucf}"),
            ],
          ));
        });
  }
}
